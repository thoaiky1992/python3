from libraries.route import controller
from libraries.route import route
from libraries.http_response import HttpResponse
import socket


@controller("health-check")
class HealthCheckController:
    @route()
    def healthCheck(self):
        print(f"hostname { socket.gethostname()}")
        hostname = socket.gethostname()
        IPAddr = socket.gethostbyname(hostname)
        return HttpResponse(
            data={"ip_address": IPAddr, "hostname": hostname}, message="ok"
        )
