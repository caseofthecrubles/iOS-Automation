#March11
from http.server import BaseHTTPRequestHandler, HTTPServer
import time
import re
from prometheus_client import start_http_server, Gauge

# Define a Gauge metric to track CO2 levels
download_gauge = Gauge('downloadspeed', ' downloadspeed')
upload_gauge = Gauge('uploadspeed', ' uploadspeed')
ping_gauge = Gauge('ping', ' ping')

hostName = "10.8.0.234"
serverPort = 8080

class MyServer(BaseHTTPRequestHandler):
    def do_GET(self):
        # Print headers
        for header in self.headers:
            print(f"{header}: {self.headers[header]}")

        client_ip, client_port = self.client_address
        print(f"Request from IP: {client_ip}, Port: {client_port}")

        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(bytes("<html><head><title>https://pythonbasics.org</title></head>", "utf-8"))
        self.wfile.write(bytes("<p>Request: %s</p>" % self.path, "utf-8"))
        self.wfile.write(bytes("<body>", "utf-8"))
        try:
            self.wfile.write(bytes(f"<p>This is your inbound header #### {header} #### </p>", "utf-8"))
        except:
            self.wfile.write(bytes(f"<p>No inbound header</p>", "utf-8"))
        self.wfile.write(bytes("</body></html>", "utf-8"))

        file1 = open(f'{client_ip}python-headder-logs.log', 'w')

        for header in self.headers:
            file1.writelines(header)
            fullhead = (f"{header}: {self.headers[header]}")
            file1.writelines(fullhead)
            print(f"{header}: {self.headers[header]}")


            if "X-Download-Speed:" in fullhead:
                download_speed_match = re.search(r"Download Speed, (\d+)megabits per second", fullhead)
                upload_speed_match = re.search(r"Upload speed, (\d+)megabits per second", fullhead)
                idle_ping_match = re.search(r"Idle ping result(\d+)milliseconds", fullhead)

                download_speed = download_speed_match.group(1) if download_speed_match else ""
                upload_speed = upload_speed_match.group(1) if upload_speed_match else ""
                idle_ping = idle_ping_match.group(1) if idle_ping_match else ""

                print("Download Speed:", download_speed, "Mbps")
                print("Upload Speed:", upload_speed, "Mbps")
                print("Idle Ping:", idle_ping, "milliseconds")

                download_speed_float = (float(download_speed))
                upload_speed_float = (float(upload_speed))
                idle_ping_float = (float(idle_ping))
    
                download_gauge.set(download_speed_float)
                upload_gauge.set(upload_speed_float)
                ping_gauge.set(idle_ping_float)

        # Closing file
        file1.close()

if __name__ == "__main__":
    webServer = HTTPServer((hostName, serverPort), MyServer)
    print("Server started http://%s:%s" % (hostName, serverPort))
    start_http_server(8081)

    try:
        webServer.serve_forever()
    except KeyboardInterrupt:
        pass

    webServer.server_close()
    print("Server stopped.")
