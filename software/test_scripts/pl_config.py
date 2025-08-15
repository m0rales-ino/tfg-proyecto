import struct
from time import sleep

CFG_TYPE_PCKT_GEN = 0x00
ENABLE_TRAFFIC_CMD = 0x01
CAPTURE_TRAFFIC_CMD = 0x02


device_ = "/dev/ethgenana" 

def set_config(trgt_chn, dest_mac, src_mac, pckt_len, gen_mode, gen_mode_param, payload_pattern, device):
    params = struct.pack('<BBQQIBII', CFG_TYPE_PCKT_GEN , trgt_chn, dest_mac, src_mac, pckt_len, gen_mode, gen_mode_param, payload_pattern)
    with open(device, "wb") as f:
        f.write(params)

def en_traffic(flags, device):
    params = struct.pack('<BB', ENABLE_TRAFFIC_CMD, flags)
    with open(device, "wb") as f:
        f.write(params)

def capture_flags(flags, device):
    params = struct.pack('<BB', CAPTURE_TRAFFIC_CMD, flags)
    with open(device, "wb") as f:
        f.write(params)

def leer_y_mostrar_stats(device):
    STATS_FORMAT = "<16I"  # 16 unsigned 32-bit ints, little-endian
    STATS_SIZE = struct.calcsize(STATS_FORMAT)

    try:
        with open(device, "rb") as f:
            data = f.read(STATS_SIZE)

        if len(data) != STATS_SIZE:
            print(f"Error: Se esperaban {STATS_SIZE} bytes pero se leyeron {len(data)}")
            return

        valores = struct.unpack(STATS_FORMAT, data)

        tx_bytes = valores[0:4]
        tx_packets = valores[4:8]
        rx_bytes = valores[8:12]
        rx_packets = valores[12:16]

        print("Estadísticas del driver:\n")

        for i in range(4):
            print(f"  TX{i}: {tx_bytes[i]} bytes, {tx_packets[i]} paquetes")

        for i in range(4):
            print(f"  RX{i}: {rx_bytes[i]} bytes, {rx_packets[i]} paquetes")

    except FileNotFoundError:
        print(f"Error: No se pudo abrir el archivo {path}")
    except Exception as e:
        print(f"Excepción inesperada: {e}")


set_config(0,0xcafebabe0001, 0xfecafeca0001, 420, 3,    0, 0xab6969 ,device_)
set_config(1,0xcafebabe0002, 0xfecafeca0002,  69, 3,   10, 0xab3434 ,device_)
set_config(2,0xcafebabe0003, 0xfecafeca0003,  64, 3, 6400, 0xab0420 ,device_)
set_config(3,0xcafebabe0004, 0xfecafeca0004, 900, 3,    0, 0xab0033 ,device_)

sleep(3)

capture_flags(0, device_)
en_traffic(0, device_)

while(1):
    leer_y_mostrar_stats(device_)
    sleep(1)
