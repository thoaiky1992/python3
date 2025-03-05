import os
import importlib


def get_controller_modules(controllers_dir: str):
    controller_modules = []

    for filename in os.listdir(controllers_dir):
        if filename.endswith("_controller.py"):
            module_name = f"controllers.{filename[:-3]}"
            module = importlib.import_module(module_name)
            controller_modules.append(module)
    return controller_modules
