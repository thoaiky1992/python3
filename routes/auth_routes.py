from controllers.auth_controller import AuthController
from libraries.view_func_handler import view_func_handler
from validation.auth.register_schema import AuthRegisterSchema
from validation.auth.login_schema import AuthLoginchema


def authRoutes(app):
    authController = AuthController()
    app.add_url_rule(
        "/api/auth/register",
        "auth_register",
        view_func=view_func_handler(
            handler=authController.register, requestBodySchema=AuthRegisterSchema
        ),
        methods=["POST"],
    )
    app.add_url_rule(
        "/api/auth/login",
        "auth_login",
        view_func=view_func_handler(
            handler=authController.login, requestBodySchema=AuthLoginchema
        ),
        methods=["POST"],
    )
