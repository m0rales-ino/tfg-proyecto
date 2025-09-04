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

rx_bytes_prev = [0,0,0,0]
tx_bytes_prev = [0,0,0,0]

rx_bytes_counter = [0,0,0,0]
tx_bytes_counter = [0,0,0,0]

tx_bytes_prev_gb = [0,0,0,0]
rx_bytes_prev_gb = [0,0,0,0]

class MyServer(BaseHTTPRequestHandler):
    def do_GET(self):

        global rx_bytes_prev, tx_bytes_prev, rx_bytes_counter, tx_bytes_counter, tx_bytes_prev_gb, rx_bytes_prev_gb
        # Decodifica la ruta (por si hay espacios, %20, etc.)
        path = unquote(self.path)

        # Si se pide un archivo (como una imagen)
        if path == "/stats":
            print("STATS")
            self.send_response(200)
            self.send_header("Content-type", "text/html; charset=utf-8")
            self.end_headers()
            try:
                with open("/opt/webserver/stats.html", "r", encoding="utf-8") as f:
                    contenido = f.read()
                    self.wfile.write(contenido.encode("utf-8"))
            except FileNotFoundError:
                self.wfile.write(b"<html><body><h1>ERROR 404:</h1><h2>stats.html Not Found</h2></body></html>")
            return
        elif path == "/get_stats":

            valores = leer_y_mostrar_stats("/dev/ethgenana")

            rx_bytes = valores[0:4]
            rx_packets = valores[4:8]
            tx_bytes = valores[8:12]
            tx_packets = valores[12:16]
            
            stats = {
                "tx_frames_1":  tx_packets[0],
                "tx_bytes_1":   tx_bytes[0],
                # "tx_bytes_1":   f"{tx_byte_gb[0]:.2f} GB",
                "rx_frames_1":  rx_packets[0],
                "rx_bytes_1":   rx_bytes[0],
                # "rx_bytes_1":   f"{rx_byte_gb[0]:.2f} GB",
                "tx_frames_2":  tx_packets[1],
                "tx_bytes_2":   tx_bytes[1],
                # "tx_bytes_2":   f"{tx_byte_gb[1]:.2f} GB",
                "rx_frames_2":  rx_packets[1],
                "rx_bytes_2":   rx_bytes[1],
                # "rx_bytes_2":   f"{rx_byte_gb[1]:.2f} GB",
                "tx_frames_3":  tx_packets[2],
                "tx_bytes_3":   tx_bytes[2],
                # "tx_bytes_3":   f"{tx_byte_gb[2]:.2f} GB",
                "rx_frames_3":  rx_packets[2],
                "rx_bytes_3":   rx_bytes[2],
                # "rx_bytes_3":   f"{rx_byte_gb[2]:.2f} GB",
                "tx_frames_4":  tx_packets[3],
                "tx_bytes_4":   tx_bytes[3],
                # "tx_bytes_4":   f"{tx_byte_gb[3]:.2f} GB",
                "rx_frames_4":  rx_packets[3],
                "rx_bytes_4":   rx_bytes[3],
                # "rx_bytes_4":   f"{rx_byte_gb[3]:.2f} GB",
                
            }
            self.send_response(200)
            self.send_header('Content-type', 'application/json; charset=utf-8')
            self.end_headers()
            self.wfile.write(json.dumps(stats).encode('utf-8'))
            return
        elif path != "/" and os.path.isfile("." + path):
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
            with open("/opt/webserver/main.html", "r", encoding="utf-8") as f:
                contenido = f.read()
                self.wfile.write(contenido.encode("utf-8"))
        except FileNotFoundError:
            self.wfile.write(b"<html><body><h1>ERROR 404:</h1><h2>Not Found</h2></body></html>")

    def do_POST(self):
        global tx_byte_gb, rx_byte_gb, rx_bytes_counter, tx_bytes_counter, rx_bytes_prev, tx_bytes_prev
        if self.path == "/config_data":
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
        
            json_str = post_data.decode('utf-8')
            config = json.loads(json_str)

            update_config(config)

            print(config)

            rx_bytes_prev = [0,0,0,0]
            tx_bytes_prev = [0,0,0,0]

            rx_bytes_counter = [0,0,0,0]
            tx_bytes_counter = [0,0,0,0]


            self.send_response(200)
            self.send_header('Content-type', 'text/plain; charset=utf-8')
            self.end_headers()
            self.wfile.write(b"Datos recibidos correctamente")
        
        elif self.path == "/enable_traffic":
            content_length = int(self.headers['Content-Length'])
            post_data = self.rfile.read(content_length)
        
            json_str = post_data.decode('utf-8')
            config = json.loads(json_str)

            flags = 0
            cc = 0
            for i in config:
                a = int(config[i]['enable'])

                flags += a*2**cc
                cc += 1 
                print(flags)
            # print(config)

            en_traffic(flags, "/dev/ethgenana")
            self.send_response(200)
            self.send_header('Content-type', 'text/plain; charset=utf-8')
            self.end_headers()
            self.wfile.write(b"Datos recibidos correctamente")

        else:
            self.send_error(404, "Not Found")
    
def update_config(config):
    for channels in config:
        for params in config[channels]:
            if params[-3:] == "mac" or params == "payload":
                config[channels][params]= int(config[channels][params].replace(":",""),16)
            elif params == "pckt_len" and config[channels][params] == '':
                config[channels][params] = 64
            else:
                config[channels][params]= int(config[channels][params],10)

    print(config)
    
    i = 0
    for channels in config:
        set_config(i,config[channels]['dest_mac'], config[channels]['source_mac'], config[channels]['pckt_len'], config[channels]['gen_mode'], config[channels]['param1'], config[channels]['param2'], config[channels]['payload'], config[channels]['loopback'], "/dev/ethgenana")
        i += 1

# def set_config(trgt_chn, dest_mac, src_mac, pckt_len, gen_mode, device):
#     params = struct.pack('<BBQQIB', CFG_TYPE_PCKT_GEN , trgt_chn, dest_mac, src_mac, pckt_len, gen_mode)
#     with open(device, "wb") as f:
#         f.write(params)

def set_config(trgt_chn, dest_mac, src_mac, pckt_len, gen_mode, gen_mode_param1, gen_mode_param2, payload_pattern, loopback_flag, device):
    params = struct.pack('<BBQQIBIHIB', CFG_TYPE_PCKT_GEN , trgt_chn, dest_mac, src_mac, pckt_len, gen_mode, gen_mode_param1, gen_mode_param2, payload_pattern, loopback_flag)
    with open(device, "wb") as f:
        f.write(params)

def en_traffic(flags, device):
    params = struct.pack('<BB', ENABLE_TRAFFIC_CMD, flags)
    with open(device, "wb") as f:
        f.write(params)
    
def leer_y_mostrar_stats(device):
    STATS_FORMAT = "<16I"  # 16 unsigned 32-bit ints, little-endian
    STATS_SIZE = struct.calcsize(STATS_FORMAT)

    with open(device, "rb") as f:
        data = f.read(STATS_SIZE)

    if len(data) != STATS_SIZE:
        print(f"Error: Se esperaban {STATS_SIZE} bytes pero se leyeron {len(data)}")
        return

    valores = struct.unpack(STATS_FORMAT, data)

    return valores



if __name__ == "__main__":        
    webServer = HTTPServer((hostName, serverPort), MyServer)
    print("Server started http://%s:%s" % (hostName, serverPort))

    try:
        webServer.serve_forever()
    except KeyboardInterrupt:
        pass

    webServer.server_close()
    print("Server stopped.")
