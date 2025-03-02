from controllers.user_controller import UserController
from libraries.view_func_handler import view_func_handler
from validation.user.create_schema import UserCreateSchema


def userRoutes(app):
    userController = UserController()
    app.add_url_rule(
        "/api/users",
        "user_findMany",
        view_func=view_func_handler(handler=userController.findMany),
        methods=["GET"],
    )
    app.add_url_rule(
        "/api/users/<int:id>",
        "user_findOne",
        view_func=view_func_handler(handler=userController.findOne),
        methods=["GET"],
    )
    app.add_url_rule(
        "/api/users",
        "user_create",
        view_func=view_func_handler(
            handler=userController.create, requestBodySchema=UserCreateSchema
        ),
        methods=["POST"],
    )
    app.add_url_rule(
        "/api/users/bulk-create",
        "user_bulk_create",
        view_func=view_func_handler(handler=userController.createMany),
        methods=["POST"],
    )

    app.add_url_rule(
        "/api/users/<int:id>",
        "user_update",
        view_func=view_func_handler(handler=userController.update),
        methods=["PUT"],
    )
    app.add_url_rule(
        "/api/users",
        "user_updateMany",
        view_func=view_func_handler(handler=userController.updateMany),
        methods=["PUT"],
    )
