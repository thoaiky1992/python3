from flask import Flask
from routes.main_routes import registerRoutes

app = Flask(__name__)

registerRoutes(app)

if __name__ == "__main__":
    app.run(debug=True, port=5000, threaded=True)
