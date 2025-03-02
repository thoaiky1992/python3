from typing import Optional, Callable
from pydantic import BaseModel
from flask import request
from libraries.http_response import HttpResponse
from pydantic import ValidationError
from libraries.logger import logger
from flask import request
import jwt
import os


def view_func_handler(
    handler: Callable,
    is_auth: bool = False,
    validate_schema: Optional[BaseModel] = None,
):
    def wrapper(*args, **kwargs):
        # Handle Authenticate
        if is_auth:
            auth_header = request.headers.get("Authorization", None)
            if auth_header is None:
                return HttpResponse(statusCode=401, message="Token's missing")
            try:
                token = str(auth_header).split(" ")[1]
                secret_token = os.getenv("SECRET_TOKEN")
                payload = jwt.decode(token, secret_token, algorithms=["HS256"])
                request.user = payload
            except Exception as e:
                logger.exception(e)
                return HttpResponse(statusCode=401)
        # validate request body
        if validate_schema is not None:
            ct = request.content_type
            if ct is not None and ct.startswith("application/json"):
                data = request.get_json()
            elif ct is not None and ct.startswith("multipart/form-data"):
                data = request.form.to_dict()
            else:
                return HttpResponse(
                    data={"error": "Unsupported Content-Type"}, statusCode=400
                )
            try:
                validate_schema(**data)
            except ValidationError as e:
                formatted_errors = []
                for error in e.errors():
                    field = error["loc"][0]
                    message = error["msg"].replace("Value error, ", "")
                    if error["type"] == "missing":
                        message = f"{field} should not be empty"
                    formatted_errors.append({"field": field, "message": message})
                return HttpResponse(data={"errors": formatted_errors}, statusCode=400)
            except Exception as e:
                logger.exception(e)
                return HttpResponse(statusCode=500)
        # controller
        return handler(*args, **kwargs)

    return wrapper
