from typing import Optional
from flask import jsonify


def HttpResponse(
    data: Optional[dict] = None,
    message: Optional[str] = None,
    statusCode: Optional[int] = 200,
):
    result = {"statusCode": statusCode}
    match statusCode:
        case 401:
            result["message"] = "Unauthorized"
            if message is not None:
                result["message"] = message
            return jsonify(result), statusCode
        case 404:
            result["message"] = "Not found"
            if message is not None:
                result["message"] = message
            return jsonify(result), statusCode
        case 500:
            if message is not None:
                result["message"] = message
            result["message"] = "Internal Server Error"
            return jsonify(result), statusCode
        case default:
            if message is not None:
                result["message"] = message
            result["data"] = data
            return jsonify(result), statusCode
