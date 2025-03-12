from pydantic import BaseModel, EmailStr, field_validator
from validation.user.create_schema import UserCreateSchema
import re


EMAIL_REGEX = re.compile(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")


class UserBulkCreateSchema(BaseModel):

    bulk: list[UserCreateSchema]

    @field_validator("bulk", mode="before")  # Run before EmailStr validation
    def validate_email(cls, v):
        if not isinstance(v, list):
            raise ValueError("bulk phải là một danh sách các UserCreateSchema")
        for user in v:
            UserCreateSchema(**user)  # Sử dụng schema để xác thực từng người dùng
        return v
