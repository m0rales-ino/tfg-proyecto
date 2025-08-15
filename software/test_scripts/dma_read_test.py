import os
import struct
from time import sleep

# Open the DMA device
dma_axis_rw_data = os.open("/dev/udmabuf0", os.O_RDWR)

cc = 0
while(1):
    # Read data through DMA
    data_rd = os.pread(dma_axis_rw_data,800,0)
    data_unpack = struct.unpack('<100Q',data_rd)
    print(f"{cc}: {data_unpack}")
    cc+=1
    sleep(1)

    data = os.pread(dma_axis_rw_data, 64, 0)  # 8 QWORDs (8*8 bytes)
    values = struct.unpack('<8Q', data)
    print(values)