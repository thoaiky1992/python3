from flask import Flask
from routes.main_routes import registerRoutes

# from tasks.task import add

app = Flask(__name__)

registerRoutes(app)

if __name__ == "__main__":
    # add.delay(30, 5)
    app.run(debug=True, port=5000, threaded=True)
