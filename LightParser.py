import re
from typing import Literal

LightType = Literal["shade", "part shade", "direct sun", "diffuse", "any"]


class LightParser:
    def __init__(self, light_description: str) -> None:
        match = re.search(r'.*[Ll]ikes? ([\w\s]+)(,|$)', light_description)

        desc_to_light_type = {
            "moderate sunshine": "moderate",
            "light": "direct sun",
            "sunshine": "direct sun",
            "half shade": "half shade",
            "half shade environment": "half shade",
            "half shade environments": "half shade",
            "scattered": "diffuse",
        }

        if not match:
            self.__light = desc_to_light_type["light"]
        else:
            desc, _ = match.groups()
            self.__light = desc_to_light_type[desc]

    @property
    def light(self) -> str:
        return self.__light
