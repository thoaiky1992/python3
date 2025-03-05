from libraries.crud_controller import CrudController
from services.user_service import UserService
from libraries.route import controller
from dependency_injector.wiring import Provide, inject
from libraries.app_container import AppContainer


@controller("users")
class UserController(CrudController[UserService]):
    @inject
    def __init__(self, user_service: UserService = Provide[AppContainer.user_service]):
        super().__init__(user_service)
