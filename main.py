import sys
import json
import asyncio

from typing import List, Literal
from PyQt6.QtCore import QCoreApplication, pyqtSignal, QObject, Qt, pyqtSlot
from PyQt6.QtGui import QGuiApplication
from PyQt6.QtQml import QQmlApplicationEngine, qmlRegisterType
from PyQt6.QtCore import pyqtProperty  # type: ignore
from PyQt6.QtQml import QQmlListProperty  # type: ignore

from LightNetwork import get_sunlight
from LightParser import LightParser, LightType

WaterType = Literal["infrequent", "moderate", "evenly", "regular", "abundant"]


class PlantCare(QObject):
    waterUpdated = pyqtSignal()
    temperatureUpdated = pyqtSignal()
    lightingUpdated = pyqtSignal()

    def __init__(self, water: WaterType, temperature: str, light: LightType = "any") -> None:
        super().__init__()
        self.__water = water
        self.__temperature = temperature
        self.__light = light

    @pyqtProperty(str, notify=waterUpdated)
    def water(self) -> str:
        return self.__water

    @pyqtProperty(str, notify=temperatureUpdated)
    def temperature(self) -> str:
        return self.__temperature

    @pyqtProperty(str, notify=lightingUpdated)
    def light(self) -> LightType:
        return self.__light

    @light.setter
    def light(self, light: LightType) -> None:
        self.__light = light
        self.lightingUpdated.emit()


class Plant(QObject):
    nameUpdated = pyqtSignal()
    pathUpdated = pyqtSignal()
    descriptionUpdated = pyqtSignal()
    careUpdated = pyqtSignal()

    def __init__(self, name: str, botanical_name: str, path: str,
                 description: str, care: PlantCare) -> None:
        super().__init__()
        self.__name = name
        self.__botanical_name = botanical_name
        self.__path = path
        self.__description = description
        self.__care = care

    @pyqtProperty(str, notify=nameUpdated)
    def name(self) -> str:
        return self.__name

    @property
    def botanical_name(self) -> str:
        return self.__botanical_name

    @pyqtProperty(str, notify=pathUpdated)
    def path(self) -> str:
        return self.__path

    @pyqtProperty(str, notify=descriptionUpdated)
    def description(self) -> str:
        return self.__description

    @pyqtProperty(PlantCare, notify=careUpdated)
    def care(self) -> PlantCare:
        return self.__care


class PlantModel(QObject):
    plantsUpdated = pyqtSignal()

    def __init__(self, plants: List[Plant]) -> None:
        super().__init__()
        self.__plants = plants

    @pyqtProperty(QQmlListProperty, notify=plantsUpdated)
    def plants(self) -> QQmlListProperty:
        return QQmlListProperty(Plant, self, self.__plants)

    async def update_light(self) -> None:
        light = await get_sunlight([plant.botanical_name for plant in self.__plants])
        for i in range(len(light)):
            self.__plants[i].care.light = LightParser(light[i]).light

    @pyqtSlot()
    def update_care(self) -> None:
        asyncio.run(self.update_light())


class ModelReader:
    def __init__(self) -> None:
        self.__path_to_model = "./plants/model.json"

    def read(self) -> List[Plant]:
        with open(self.__path_to_model) as f:
            read_plants = json.load(f)["plants"]
        plants = []
        for plant in read_plants:
            care = PlantCare(**plant["care"])
            del plant["care"]
            plants.append(Plant(**plant, care=care))
        return plants


if __name__ == '__main__':
    QCoreApplication.setAttribute(Qt.ApplicationAttribute.AA_ShareOpenGLContexts)
    app = QGuiApplication(sys.argv)
    qmlRegisterType(PlantCare, 'PlantCare', 1, 0, 'PlantCare')

    engine = QQmlApplicationEngine()
    engine.addImportPath("modules")
    engine.quit.connect(app.quit)  # type: ignore

    plants = ModelReader().read()
    plant_model = PlantModel(plants)
    engine.setInitialProperties({"plantModel": plant_model})
    engine.load('qml/main.qml')
    sys.exit(app.exec())
