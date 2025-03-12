from libraries.crud_controller import CrudController
from services.user_service import UserService
from libraries.route import controller, route
from dependency_injector.wiring import Provide, inject
from libraries.app_container import AppContainer, appContainerInstance
from validation.user.create_schema import UserCreateSchema
from validation.user.bulk_create_schema import UserBulkCreateSchema


@controller("users")
class UserController(CrudController[UserService]):
    @inject
    def __init__(self, user_service: UserService = Provide[AppContainer.user_service]):
        super().__init__(user_service)

    @route("", method="POST", validate_schema=UserCreateSchema)
    def create(self):
        return super().create()

    @route("/bulk-create", method="POST", validate_schema=UserBulkCreateSchema)
    def createMany(self):
        return super().createMany()


appContainerInstance.wire(modules=[__name__])
