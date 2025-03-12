from typing import Optional, Callable
from pydantic import BaseModel
from middlewares.validate_schema_middleware import validate_schema_middleware
from middlewares.authenticate_middleware import authenticate_middleware


def view_func_handler(
    handler: Callable,
    is_auth: bool = False,
    validate_schema: Optional[BaseModel] = None,
):
    def wrapper(*args, **kwargs):
        # Handle Authenticate
        if is_auth:
            authenticate_response = authenticate_middleware()
            if authenticate_response:
                return authenticate_response
        # validate request body
        if validate_schema is not None:
            validate_schema_response = validate_schema_middleware(validate_schema)
            if validate_schema_response:
                return validate_schema_response
        # view_handler
        return handler(*args, **kwargs)

    return wrapper
