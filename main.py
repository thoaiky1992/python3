from flask import Flask
from routes.main_routes import registerRoutes
from gevent.pywsgi import WSGIServer
import os


app = Flask(__name__)

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

