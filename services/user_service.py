from libraries.crud_service import CrudService
from services.prisma_service import prismaService
from prisma.models import User
from typing import Optional


class UserService(CrudService[type(prismaService.client.user), User]):
    def __init__(self):
        super().__init__(prismaService.client.user)

    def findOneByEmail(self, email: str) -> Optional[User]:
        return self.model.find_first(where={"email": email})
