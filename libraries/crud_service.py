from typing import TypeVar, Generic, Optional, List
from abc import ABC, abstractmethod

M = TypeVar("M")
M = TypeVar("M")


class AbstractCrudService(ABC, Generic[M]):
    @property
    @abstractmethod
    def model(self) -> M:
        pass

    @abstractmethod
    def findMany(self) -> List[M]:
        pass

    @abstractmethod
    def findOne(self) -> Optional[M]:
        pass

    @abstractmethod
    def create(self) -> M:
        pass

    @abstractmethod
    def createMany(self) -> List[M]:
        pass

    @abstractmethod
    def update(self) -> Optional[M]:
        pass

    @abstractmethod
    def updateMany(self) -> int:
        pass

    @abstractmethod
    def delete(self) -> Optional[M]:
        pass

    @abstractmethod
    def deleteMany(self) -> int:
        pass


class CrudService(AbstractCrudService[M]):
    def __init__(self, model: M):
        self.__model = model

    @property
    def model(self) -> M:
        return self.__model

    def findMany(self) -> List[M]:
        return self.model.prisma().find_many()

    def findOne(self, id: int) -> Optional[M]:
        return self.model.prisma().find_first(where={"id": id})

    def create(self, data) -> M:
        return self.model.prisma().create(data=data)

    def createMany(self, data) -> List[M]:
        return self.model.prisma().create_many(data=data)

    def update(self, id: int, update_data: dict) -> Optional[M]:
        return self.model.prisma().update(where={"id": id}, data=update_data)

    def updateMany(self, where: dict, data: dict) -> int:
        return self.model.prisma().update_many(where=where, data=data)

    def delete(self, id: int) -> Optional[M]:
        return self.model.prisma().delete(where={"id": id})

    def deleteMany(self, where: dict) -> int:
        return self.model.prisma().delete_many(where=where)
