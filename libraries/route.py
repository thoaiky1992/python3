from functools import wraps
from typing import Optional
from pydantic import BaseModel
from utils.string import normalize_path
from libraries.view_func_handler import view_func_handler
from flask import Flask


def controller(base_path: str):
    def decorator(cls):
        cls.base_path = base_path
        return cls

    return decorator


def route(
    path: str = "",
    method: str = "GET",
    validate_schema: Optional[BaseModel] = None,
    is_auth: bool = False,
):
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            return func(*args, **kwargs)

        wrapper.route_path = path
        wrapper.route_method = method
        wrapper.validate_schema = validate_schema
        wrapper.is_auth = is_auth
        return wrapper

    return decorator


def register_routes(app: Flask, controllers):
    for controller in controllers:
        c = controller()
        for attr_name in dir(c):
            attr = getattr(c, attr_name)
            if (
                callable(attr)
                and hasattr(attr, "route_path")
                and hasattr(attr, "route_method")
            ):
                base_path = normalize_path("api", c.base_path)
                end_point = normalize_path(base_path, attr.route_path)
                app.add_url_rule(
                    end_point,
                    f"{attr_name}___{end_point}",
                    view_func=view_func_handler(
                        handler=attr,
                        validate_schema=attr.validate_schema,
                        is_auth=attr.is_auth,
                    ),
                    methods=[attr.route_method],
                )
