from flask import request
from libraries.http_response import HttpResponse
from pydantic import ValidationError
from libraries.logger import logger
from pydantic import BaseModel


def validate_schema_middleware(validate_schema: BaseModel):

    ct = request.content_type
    if ct is not None and ct.startswith("application/json"):
        data = request.get_json()
    elif ct is not None and ct.startswith("multipart/form-data"):
        data = request.form.to_dict()
    else:
        return HttpResponse(data={"error": "Unsupported Content-Type"}, statusCode=400)
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
    return None
