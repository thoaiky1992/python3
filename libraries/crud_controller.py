from flask import request, Response
from typing import TypeVar, Generic
from libraries.logger import logger
from libraries.http_response import HttpResponse
from libraries.route import route
from abc import ABC, abstractmethod

S = TypeVar("S")


class AbstractCrudController(ABC, Generic[S]):

    @property
    @abstractmethod
    def service(self) -> S:
        pass

    @abstractmethod
    def findMany(self) -> tuple[Response, int | None]:
        pass

    @abstractmethod
    def findOne(self) -> tuple[Response, int | None]:
        pass

    @abstractmethod
    def create(self) -> tuple[Response, int | None]:
        pass

    @abstractmethod
    def createMany(self) -> tuple[Response, int | None]:
        pass

    @abstractmethod
    def update(self) -> tuple[Response, int | None]:
        pass

    @abstractmethod
    def updateMany(self) -> tuple[Response, int | None]:
        pass

    @abstractmethod
    def delete(self) -> tuple[Response, int | None]:
        pass

    @abstractmethod
    def deleteMany(self) -> tuple[Response, int | None]:
        pass


class CrudController(AbstractCrudController[S]):
    def __init__(self, service: S):
        self.__service = service

    @property
    def service(self) -> S:
        return self.__service

    @route("", method="GET")
    def findMany(self):
        try:
            records = self.service.findMany()
            return HttpResponse(data=[r.model_dump() for r in records], statusCode=200)
        except Exception as e:
            logger.exception(e)  # like calling logging.error(e, exc_info=True)
            return HttpResponse(statusCode=500)

    @route("<int:id>", method="GET")
    def findOne(self, id: int):
        try:
            record = self.service.findOne(id)
            if not record:
                return HttpResponse(data=None, statusCode=404)
            return HttpResponse(data=record.model_dump(), statusCode=200)
        except Exception as e:
            logger.exception(e)
            return HttpResponse(statusCode=500)

    @route("", method="POST")
    def create(self):
        try:
            data = request.get_json()
            record = self.service.create(data)
            return HttpResponse(data=record.model_dump(), statusCode=201)
        except Exception as e:
            logger.exception(e)
            return HttpResponse(statusCode=500)

    @route("bulk-create", method="POST")
    def createMany(self):
        try:
            data = request.get_json()
            count = self.service.createMany(data["bulk"])
            return HttpResponse(data={"count": count}, statusCode=201)
        except Exception as e:
            logger.exception(e)
            return HttpResponse(statusCode=500)

    @route("<int:id>", method="PUT")
    def update(self, id: int):
        try:
            data = request.get_json()
            record = self.service.findOne(id)
            if not record:
                return HttpResponse(data=None, statusCode=404)
            update_record = self.service.update(id, data)
            return HttpResponse(data=update_record.model_dump(), statusCode=200)
        except Exception as e:
            logger.exception(e)
            return HttpResponse(statusCode=500)

    @route("", method="PUT")
    def updateMany(self):
        try:
            data = request.get_json()
            count = self.service.updateMany(data["where"], data["data"])
            return HttpResponse(data={"count": count}, statusCode=200)
        except Exception as e:
            logger.exception(e)
            return HttpResponse(statusCode=500)

    @route("<int:id>", method="DELETE")
    def delete(self, id):
        try:
            record = self.service.findOne(id)
            if not record:
                return HttpResponse(data=None, statusCode=404)
            delete_record = self.service.delete(id)
            return HttpResponse(data=delete_record.model_dump(), statusCode=200)
        except Exception as e:
            logger.exception(e)
            return HttpResponse(statusCode=500)

    @route("", method="DELETE")
    def deleteMany(self):
        try:
            data = request.get_json()
            count = self.service.deleteMany(data["where"])
            return HttpResponse(data={"count": count}, statusCode=200)
        except Exception as e:
            logger.exception(e)
            return HttpResponse(statusCode=500)
