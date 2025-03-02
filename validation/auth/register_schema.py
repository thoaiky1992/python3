from pydantic import BaseModel, EmailStr, field_validator
import re


EMAIL_REGEX = re.compile(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")


class AuthRegisterSchema(BaseModel):
    name: str
    email: EmailStr
    password: str

    @field_validator("name")  # Run before default type validation
    @classmethod
    def validate_name(cls, v):
        if len(v) < 8:
            raise ValueError("Field must have at least 8 characters")
        return v

    @field_validator("email", mode="before")  # Run before EmailStr validation
    def validate_email(cls, v):
        if not isinstance(v, str) or not EMAIL_REGEX.match(v):
            raise ValueError(
                "Email must be a valid email address (example: abc@gmail.com)"
            )
        return v  # EmailStr will handle further validation
