from flask import Flask
from routes.main_routes import registerRoutes
from libraries.app_container import AppContainer
from utils.get_controller_modules import get_controller_modules
import os
from gevent.pywsgi import WSGIServer

app = Flask(__name__)

# Register Container
controllers_dir = os.path.join(os.path.dirname(__file__), "controllers")
controller_modules = get_controller_modules(controllers_dir)
container = AppContainer()
container.wire(modules=[__name__, *controller_modules])

# Register routes
registerRoutes(app)

if __name__ == "__main__":
    py_env = os.getenv("PY_ENV")
    port = int(os.getenv("PORT") or 4000)

    if py_env == "prod":
        http_server = WSGIServer(("0.0.0.0", port), app)
        http_server.serve_forever()
    else:
        app.run(debug=True, port=port, host="0.0.0.0", threaded=True)
