from flask import request
from typing import TypeVar, Generic
from libraries.logger import logger
from libraries.http_response import HttpResponse

S = TypeVar("S")


class CrudController(Generic[S]):
    def __init__(self, service: S):
        self.service = service

    def findMany(self):
        try:
            records = self.service.findMany()
            return HttpResponse(data=[r.model_dump() for r in records], statusCode=200)
        except Exception as e:
            logger.exception(e)  # like calling logging.error(e, exc_info=True)
            return HttpResponse(statusCode=500)

    def findOne(self, id: int):
        try:
            record = self.service.findOne(id)
            if not record:
                return HttpResponse(data=None, statusCode=404)
            return HttpResponse(data=record.model_dump(), statusCode=200)
        except Exception as e:
            logger.exception(e)
            return HttpResponse(statusCode=500)

    def create(self):
        try:
            data = request.get_json()
            record = self.service.create(data)
            return HttpResponse(data=record.model_dump(), statusCode=201)
        except Exception as e:
            logger.exception(e)
            return HttpResponse(statusCode=500)

    def createMany(self):
        try:
            data = request.get_json()
            count = self.service.createMany(data["bulk"])
            return HttpResponse(data={"count": count}, statusCode=201)
        except Exception as e:
            logger.exception(e)
            return HttpResponse(statusCode=500)

    def update(self, id: int):
        try:
            data = request.get_json()
            record = self.service.update(id, data)
            return HttpResponse(data=record.model_dump(), statusCode=200)
        except Exception as e:
            logger.exception(e)
            return HttpResponse(statusCode=500)

    def updateMany(self):
        try:
            data = request.get_json()
            count = self.service.updateMany(data["where"], data["data"])
            return HttpResponse(data={"count": count}, statusCode=200)
        except Exception as e:
            logger.exception(e)
            return HttpResponse(statusCode=500)
