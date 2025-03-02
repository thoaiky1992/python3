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
            return jsonify(result), statusCode
        case 500:
            result["message"] = "Internal Server Error"
            return jsonify(result), statusCode
        case default:
            if message is not None:
                result["message"] = message
            return jsonify(result), statusCode
