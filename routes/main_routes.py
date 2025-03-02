from routes.auth_routes import authRoutes
from routes.user_routes import userRoutes


def registerRoutes(app):
    authRoutes(app)
    userRoutes(app)
