import re


def normalize_path(prefix: str, path: str = "") -> str:
    str = "/" + prefix.strip("/")
    if path:
        str += "/" + path.strip("/")
    return re.sub(r"/+", "/", str)
