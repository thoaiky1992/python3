from libraries.crud_controller import CrudController
from services.user_service import UserService
from libraries.route import controller


@controller("users")
class UserController(CrudController[UserService]):
    def __init__(self):
        super().__init__(UserService())
