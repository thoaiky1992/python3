from typing import TypeVar, Generic, Optional, List

M = TypeVar("M")
D = TypeVar("D")


class CrudService(Generic[M, D]):
    def __init__(self, model: M):
        self.model = model

    def findMany(self) -> List[D]:
        return self.model.find_many()

    def findOne(self, id: int) -> Optional[D]:
        return self.model.find_first(where={"id": id})

    def create(self, data) -> D:
        return self.model.create(data=data)

    def createMany(self, data) -> List[D]:
        return self.model.create_many(data=data)

    def update(self, id: int, update_data: dict) -> D:
        return self.model.update(where={"id": id}, data=update_data)

    def updateMany(self, where: dict, data: dict):
        return self.model.update_many(where=where, data=data)

    def delete(self, id: int):
        return self.model.delete(where={"id": id})

    def deleteMany(self, where: dict):
        return self.model.delete_many(where=where)
