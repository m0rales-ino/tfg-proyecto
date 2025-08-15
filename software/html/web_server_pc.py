# Python 3 server example
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import unquote
import os
import mimetypes
import json
import subprocess
import struct

CFG_TYPE_PCKT_GEN = 0x00
ENABLE_TRAFFIC_CMD = 0x01

hostName = "0.0.0.0"
serverPort = 8080

class MyServer(BaseHTTPRequestHandler):
    def do_GET(self):
        # Decodifica la ruta (por si hay espacios, %20, etc.)
        path = unquote(self.path)

        # Si se pide un archivo (como una imagen)
        if path != "/" and os.path.isfile("." + path):
            # Detecta el tipo MIME (image/png, image/jpeg, etc.)
            mime_type, _ = mimetypes.guess_type(path)
            try:
                with open("." + path, "rb") as f:
                    self.send_response(200)
                    self.send_header("Content-type", mime_type or "application/octet-stream")
                    self.end_headers()
                    self.wfile.write(f.read())
            except Exception as e:
                self.send_error(500, f"Error interno del servidor: {e}")
            return
        
        

        # Si se pide la raíz o algo que no es un archivo, sirve el HTML
        self.send_response(200)
        self.send_header("Content-type", "text/html; charset=utf-8")
        self.end_headers()
        try:
            #with open("main3.html", "r", encoding="utf-8") as f:
            with open("main.html", "r", encoding="utf-8") as f:
                contenido = f.read()
                self.wfile.write(contenido.encode("utf-8"))
        except FileNotFoundError:
            self.wfile.write(b"<html><body><h1>ERROR 404:</h1><h2>Not Found</h2></body></html>")

    def do_POST(self):
        if self.path == "/config_data":
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
        
            json_str = post_data.decode('utf-8')
            config = json.loads(json_str)

            update_config(config)

            print(config)


            self.send_response(200)
            self.send_header('Content-type', 'text/plain; charset=utf-8')
            self.end_headers()
            self.wfile.write(b"Datos recibidos correctamente")
        
        elif self.path == "/enable_traffic":
            en_traffic(0xF, "/dev/ethgenana")

        else:
            self.send_error(404, "Not Found")
    
def update_config(config):
    for channels in config:
        for params in config[channels]:
            print(params[-3:])
            if params[-3:] == "mac" or params == "payload":
                config[channels][params]= int(config[channels][params].replace(":",""),16)
            elif params == "pckt_len" and config[channels][params] == '':
                config[channels][params] = 64
            else:
                config[channels][params]= int(config[channels][params],10)
    
    i = 0
    for channels in config:
        set_config(i,config[channels]['dest_mac'], config[channels]['source_mac'], config[channels]['pckt_len'], config[channels]['gen_mode'], config[channels]['param1'], config[channels]['param2'], config[channels]['enable'], config[channels]['loopback'], config[channels]['payload'], "/dev/ethgenana")
        i += 1

def set_config(trgt_chn, dest_mac, src_mac, pckt_len, gen_mode, gen_mode_param_1, gen_mode_param_2, payload_pattern, enable, loopback, device):
    print(f"Channel: {trgt_chn}\nDest MAC: {hex(dest_mac)}\nSource MAC: {hex(src_mac)}\nPacket Length: {pckt_len}\nGen mode: {gen_mode}\nParam1: {gen_mode_param_1}\nParam2: {gen_mode_param_2}\nPayload: {hex(payload_pattern)}\nEnable: {enable}\nLoopback: {'loopback'}\n\n\n")

def en_traffic(flags, device):
    print(f"Flags: {flags}")

def leer_y_mostrar_stats(device):
    print("Leyendo")
    
        


if __name__ == "__main__":        
    webServer = HTTPServer((hostName, serverPort), MyServer)
    print("Server started http://%s:%s" % (hostName, serverPort))

    try:
        webServer.serve_forever()
    except KeyboardInterrupt:
        pass

    webServer.server_close()
    print("Server stopped.")
