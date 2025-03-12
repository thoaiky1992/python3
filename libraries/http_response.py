from typing import Optional
from flask import jsonify


def HttpResponse(
    data: Optional[dict] = None,
    message: Optional[str] = None,
    statusCode: Optional[int] = 200,
):
    result = {"statusCode": statusCode, "data": data}
    match statusCode:
        case 401:
            result["message"] = "Unauthorized"
            pass
        case 403:
            result["message"] = "Forbidden"
            pass
        case 404:
            result["message"] = "Not found"
            pass
        case 500:
            result["message"] = "Internal Server Error"
            pass
        case default:
            pass
    if message is not None:
        result["message"] = message
    return jsonify(result), statusCode
