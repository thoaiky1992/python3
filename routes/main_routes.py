from libraries.route import register_routes
from flask import Flask
from controllers.auth_controller import AuthController
from controllers.user_controller import UserController
from controllers.health_check_controller import HealthCheckController


def registerRoutes(app: Flask):
    register_routes(app, [AuthController, UserController, HealthCheckController])
