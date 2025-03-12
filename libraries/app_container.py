from dependency_injector import containers, providers
from services.user_service import UserService


class AppContainer(containers.DeclarativeContainer):
    user_service = providers.Singleton(UserService)

appContainerInstance = AppContainer()