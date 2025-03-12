from flask import request
from libraries.logger import logger
from libraries.http_response import HttpResponse
import bcrypt
import jwt
import os
from datetime import datetime, timedelta
from services.user_service import UserService
from libraries.route import controller, route
from validation.auth.login_schema import AuthLoginchema
from validation.auth.register_schema import AuthRegisterSchema
from dependency_injector.wiring import Provide, inject
from libraries.app_container import AppContainer, appContainerInstance


@controller("auth")
class AuthController:
    @inject
    def __init__(self, user_service: UserService = Provide[AppContainer.user_service]):
        self.userService = user_service

    @route("register", method="POST", validate_schema=AuthRegisterSchema)
    def register(self):
        try:
            data = request.get_json()
            user = self.userService.findOneByEmail(data["email"])
            if user:
                return HttpResponse(
                    message="This email have been existed", statusCode=409
                )
            hashed_password = bcrypt.hashpw(
                data["password"].encode("utf-8"), bcrypt.gensalt()
            )
            data["password"] = hashed_password.decode("utf-8")
            user = self.userService.create(data=data)
            return HttpResponse(data=user.model_dump(), statusCode=200)
        except Exception as e:
            logger.exception(e)
            return HttpResponse(statusCode=500)

    @route("login", method="POST", validate_schema=AuthLoginchema)
    def login(self):
        try:
            body = request.get_json()
            user = self.userService.findOneByEmail(body["email"])
            if user is None:
                return HttpResponse(
                    message=f"The account with this email haven't been existed",
                    statusCode=404,
                )
            password = body["password"].encode("utf-8")
            user_password = user.password.encode("utf-8")
            is_match = bcrypt.checkpw(password, user_password)

            if is_match == False:
                return HttpResponse(message="The password's incorrect ", statusCode=401)

            # now + 30m and parse to timestamp
            timestamp = (datetime.now() + timedelta(minutes=30)).timestamp()

            payload = {
                "user_id": user.id,
                "email": user.email,
                "exp": timestamp,
            }
            secret_token = os.getenv("SECRET_TOKEN")
            token = jwt.encode(payload, secret_token, algorithm="HS256")
            user_data = user.model_dump()
            if "password" in user_data:
                del user_data["password"]
            data = {"user": user_data, "token": token, "exp": timestamp}
            return HttpResponse(data=data, statusCode=200)
        except Exception as e:
            logger.exception(e)
            return HttpResponse(statusCode=500)


appContainerInstance.wire(modules=[__name__])
