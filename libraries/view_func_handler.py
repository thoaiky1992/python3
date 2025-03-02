from typing import Optional, Callable
from pydantic import BaseModel
from flask import request
from libraries.http_response import HttpResponse
from pydantic import ValidationError


def view_func_handler(
    handler: Callable,
    isAuth: bool = False,
    requestBodySchema: Optional[BaseModel] = None,
):
    def wrapper(*args, **kwargs):
        # Handle Authenticate
        if isAuth:
            user = getattr(request, "user", None)
            if not user:
                return HttpResponse(message="Unauthorized", statusCode=401)
        # validate request body
        if requestBodySchema is not None:
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
                requestBodySchema(**data)
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
                return HttpResponse(statusCode=500)
        # controller
        return handler(*args, **kwargs)

    return wrapper
