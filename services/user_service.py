from libraries.crud_service import CrudService
from prisma.models import User
from typing import Optional
import bcrypt


class UserService(CrudService[User]):
    def __init__(self):
        super().__init__(User)

    def findOneByEmail(self, email: str) -> Optional[User]:
        return self.model.prisma().find_first(where={"email": email})

    def createNewUser(self, data) -> User:
        hashed_password = bcrypt.hashpw(
            data["password"].encode("utf-8"), bcrypt.gensalt()
        )
        data["password"] = hashed_password.decode("utf-8")
        return self.create(data)
