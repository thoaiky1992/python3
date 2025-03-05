from flask import Flask
from routes.main_routes import registerRoutes
from libraries.app_container import AppContainer
from utils.get_controller_modules import get_controller_modules
import os

app = Flask(__name__)

# Register Container
controllers_dir = os.path.join(os.path.dirname(__file__), "controllers")
controller_modules = get_controller_modules(controllers_dir)
container = AppContainer()
container.wire(modules=[__name__, *controller_modules])

# Register routes
registerRoutes(app)

if __name__ == "__main__":
    app.run(debug=True, port=5000, threaded=True)
