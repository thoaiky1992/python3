from pydantic import BaseModel, EmailStr, field_validator
from prisma.models import User
import re


EMAIL_REGEX = re.compile(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")


class UserCreateSchema(BaseModel):

    name: str
    email: EmailStr
    password: str

    @field_validator("name", mode="before")  # Run before default type validation
    def validate_name(cls, v):
        if not isinstance(v, str):
            raise ValueError(f"name '{v}' phải là 1 string")
        if len(v) < 8:
            raise ValueError(f"Name '{v}' phải có ít nhất 8 ký tự")
        return v

    @field_validator("email", mode="before")  # Run before EmailStr validation
    def validate_email(cls, v):
        user = User.prisma().find_first(where={"email": v})
        if user:
            raise ValueError(f"Email '{v}' này đã tồn tại trong DB")
        if not isinstance(v, str) or not EMAIL_REGEX.match(v):
            raise ValueError(
                "email phải là địa chỉ email hợp lệ (ví dụ: user@example.com)"
            )
        return v  # EmailStr will handle further validation
