from flask import request
from libraries.http_response import HttpResponse
from libraries.logger import logger
import jwt
import os


def authenticate_middleware():
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
    return None
