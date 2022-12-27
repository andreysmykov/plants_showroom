import json
import asyncio
import aiohttp

from typing import Any, List


async def get_plant(session: aiohttp.ClientSession, name: str) -> Any:
    plant_database_url = "https://raw.githubusercontent.com/vrachieru/plant-database/master/json/"
    async with session.get(plant_database_url + name + ".json") as response:
        data = await response.read()
    return json.loads(data)


async def get_sunlight(plant_bot_names: List[str]) -> List[str]:
    async with aiohttp.ClientSession() as session:
        responses = await asyncio.gather(*[get_plant(session, name) for name in plant_bot_names])
        sunlight = [r["maintenance"]["sunlight"] for r in responses]
    return sunlight
