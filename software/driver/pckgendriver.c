#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/fs.h>
#include <linux/types.h>
#include <linux/io.h>
#include <linux/uaccess.h>
#include <linux/cdev.h>
#include <linux/device.h>

#include "eth_gen_ana_lib.h"

static int major;
static struct class*  class  = NULL;
static struct device* device = NULL;
static struct cdev cdev;

//Puntero hacia los registros. __iomem indica que es memoria I/O mapeada, no RAM
static void __iomem *axi_pckt_gen = NULL;

static void __iomem *axi_eth_channels[4] = { NULL };

#define DEVICE_NAME "ethgenana"
#define CLASS_NAME  "pcktgen"



typedef struct {
    u8  trgt_chn;
    u64 dest_mac;
    u64 src_mac;
    u32 pckt_len;
    u8  gen_mode;
    u32 gen_mode_param;
    u32 payload_pattern;
    u8  loopback_flg;
    u8  enable_flg;
} __attribute__((packed)) config_pckt_gen;

typedef struct{
    u8 trgt_chn;
    u8 lb_flg;
} __attribute__((packed)) mac_config;

typedef struct{
    u32 tx_bytes[4];
    u32 tx_packets[4];
    u32 rx_bytes[4];
    u32 rx_packets[4];
} __attribute__((packed)) stats;

int dest_mac_config(u64 mac, u8 chn);
int gen_mode_config(u8 mode, u32 param, u8 chn);
int gen_mode_burst(u16 pckts_per_burst, u16 cycles_per_halt, u8 chn);
int set_payload_length(u16 len, u8 chn);
int src_mac_config(u64 mac, u8 chn);
int set_payload_pattern(u32 pattern, u8 chn);
int set_enable(u8 flags);
int set_capture_flags(u8 flags);
// int configure_ETH_MAC(u8 eth_channel_flag, u8 loopback_flag, void __iomem *axi_array);
int set_pcktgen_config(config_pckt_gen param);
u32 stats_read(s8 chn, u8 packet_or_byte);


static int open_op(struct inode *inodep, struct file *filep) {
    pr_info(KERN_INFO "Ethernet Generator/Analyzer: dispositivo abierto\n");
    return 0;
}

static ssize_t read_op(struct file *filep, char *buffer, size_t len, loff_t *offset) {
    
    

    stats estadisticas;
    size_t struct_size = sizeof(estadisticas);
    int i;

    if (len < struct_size)
        return -EINVAL;
    
    for (i = 0; i < 4; i++) {
        estadisticas.tx_bytes[i] = stats_read(i + 1, 1);
        estadisticas.tx_packets[i] = stats_read(i + 1, 0);
        estadisticas.rx_bytes[i] = stats_read(-(i + 1), 1);
        estadisticas.rx_packets[i] = stats_read(-(i + 1), 0);
    }

    if (copy_to_user(buffer, &estadisticas, struct_size))
        return -EFAULT;
    
    return struct_size;
}

static ssize_t write_op(struct file *filep, const char *buffer, size_t len, loff_t *offset) {
    char cmd;
    config_pckt_gen params;
    char kbuf[100];
    size_t to_copy = min(len,sizeof(kbuf)-1);
    size_t i = 0;
    

    pr_info("Ethernet Generator/Analizer: escritura en dispositivo");

    if (!buffer || len == 0)
    return -EINVAL;

     if (copy_from_user(kbuf, buffer, to_copy)) {
        return -EFAULT;
    }

    kbuf[to_copy] = '\0';

    printk(KERN_INFO "my_driver: write buffer as hex:");
    for (i = 0; i < to_copy; ++i) {
        printk(KERN_CONT " %02x", (unsigned char)kbuf[i]);
    }
    
    // cmd at the first received byte symbolizes if the configuratino is directed to pckt_gen or eth_macs
    
    if (copy_from_user(&cmd, buffer, 1))
        return -EFAULT;

    switch (cmd)
    {
    // In case it is pckt_gen, the msg will be parsed into config_pckt_gen struct
    case CFG_TYPE_PCKT_GEN: // Configure Packet Generator
        
        if (len < 1 + sizeof(params)) {
            pr_info("Ethernet Generator/Analyzer: paquete write demasiado corto\n");
            return -EINVAL;
        }

        if (copy_from_user(&params, buffer+1, sizeof(params))) {
            return -EFAULT;
        }

        // Configuring the parameters
        set_pcktgen_config(params);

        break;  
    
    case 0x01: // Enable traffic
        if (len > 2) {
            pr_info("Ethernet Generator/Analyzer: paquete write demasiado largo\n");
            return -EINVAL;
        }
        set_enable(buffer[1]);
        break;
    
    case 0x02:
        if (len > 2) {
            pr_info("Ethernet Generator/Analyzer: paquete write demasiado largo\n");
            return -EINVAL;
        }
        set_capture_flags(buffer[1]);
    default:
        pr_info("Ethernet Generator/Analyzer: comando desconocido\n");
        break;
    }


    pr_info("Ethernet Generator/Analizer: nueva configuración aplicada\n");
    return len;
}

static int release_op(struct inode *inodep, struct file *filep) {
    pr_info(KERN_INFO "Ethernet Generator/Analyzer dispositivo cerrado\n");
    return 0;
}


static struct file_operations fops = {
    .open = open_op,
    .read = read_op,
    .write = write_op,
    .release = release_op,
};

static int __init init_driver(void) {
    // Kernel logging
    pr_info(KERN_INFO "Ethernet Generator/Analyzer: iniciando\n");

    major = register_chrdev(0, DEVICE_NAME, &fops);
    if (major < 0) {
        pr_err(KERN_ALERT "Ethernet Generator/Analyzer: fallo al registrar major\n");
        return major;
    }

    class = class_create(THIS_MODULE, CLASS_NAME);
    if (IS_ERR(class)) {
        unregister_chrdev(major, DEVICE_NAME);
        return PTR_ERR(class);
    }

    device = device_create(class, NULL, MKDEV(major, 0), NULL, DEVICE_NAME);
    if (IS_ERR(device)) {
        class_destroy(class);
        unregister_chrdev(major, DEVICE_NAME);
        return PTR_ERR(device);
    }
        cdev_init(&cdev, &fops);
    cdev_add(&cdev, MKDEV(major, 0), 1);

    axi_pckt_gen = ioremap(PCKT_GEN_BA, AXI_MAP_SIZE);
    if (!axi_pckt_gen) {
        pr_err(KERN_ALERT "Error mapeando AXI Packet Generator\n");
        return -ENOMEM;
    }

    axi_eth_channels[0] = ioremap(ETH_MAC0_BA, AXI_MAP_SIZE);
    if (!axi_eth_channels[0]) {
        pr_err(KERN_ALERT "Error mapeando AXI Eth MAC 0\n");
        return -ENOMEM;
    }

    axi_eth_channels[1] = ioremap(ETH_MAC1_BA, AXI_MAP_SIZE);
    if (!axi_eth_channels[1]) {
        pr_err(KERN_ALERT "Error mapeando AXI Eth MAC 1\n");
        return -ENOMEM;
    }

    axi_eth_channels[2] = ioremap(ETH_MAC2_BA, AXI_MAP_SIZE);
    if (!axi_eth_channels[2]) {
        pr_err(KERN_ALERT "Error mapeando AXI Eth MAC 2\n");
        return -ENOMEM;
    }

    axi_eth_channels[3] = ioremap(ETH_MAC3_BA, AXI_MAP_SIZE);
    if (!axi_eth_channels[3]) {
        pr_err(KERN_ALERT "Error mapeando AXI Eth MAC 3\n");
        return -ENOMEM;
    }


    pr_info(KERN_INFO "Ethernet Generator/Analyzer: cargado correctamente con major %d\n", major);
    return 0;
}

static void __exit exit_driver(void) {
    if (axi_pckt_gen)
        iounmap(axi_pckt_gen);

    if (axi_eth_channels[0])
        iounmap(axi_eth_channels[0]);

    if (axi_eth_channels[1])
        iounmap(axi_eth_channels[1]);

    if (axi_eth_channels[2])
        iounmap(axi_eth_channels[2]);

    if (axi_eth_channels[3])
        iounmap(axi_eth_channels[3]);

    device_destroy(class, MKDEV(major, 0));
    class_destroy(class);
    unregister_chrdev(major, DEVICE_NAME);
    pr_info(KERN_INFO "Ethernet Generator/Analyzer descargado\n");
}

int dest_mac_config(u64 mac, u8 chn){
    // Reading the content of the mode_registers to apply mask in writing
    u32 prev_value = 0;
    
    switch (chn)
    {
    case 0:
        // Write lower part of dest_MAC_0
        iowrite32((u32)mac, axi_pckt_gen + OFFSET_DEST_MAC_0_LOW);

        //Writes upper part of dest_MAC_0
        prev_value = ioread32(axi_pckt_gen + OFFSET_DEST_MAC_0_HIGH);
        prev_value = (prev_value & 0xFFFF0000) | (u32)(mac >> 32);
        iowrite32(prev_value, axi_pckt_gen + OFFSET_DEST_MAC_0_HIGH);
        break;
    
    case 1:
        // Write lower part of dest_MAC_0
        iowrite32((u32)mac, axi_pckt_gen + OFFSET_DEST_MAC_1_LOW);

        //Writes upper part of dest_MAC_0
        prev_value = ioread32(axi_pckt_gen + OFFSET_DEST_MAC_1_HIGH);
        prev_value = (prev_value & 0x0000FFFF) | ((u32)(mac >> 16)& 0xFFFF0000); // these offsets are going to be magic numbers, im too lazy to set these as macros
        iowrite32(prev_value, axi_pckt_gen + OFFSET_DEST_MAC_1_HIGH);
        break;

    case 2:
        // Write lower part of dest_MAC_0
        iowrite32((u32)mac, axi_pckt_gen + OFFSET_DEST_MAC_2_LOW);

        //Writes upper part of dest_MAC_0
        prev_value = ioread32(axi_pckt_gen + OFFSET_DEST_MAC_2_HIGH);
        prev_value = (prev_value & 0xFFFF0000) | (u32)(mac >> 32); // these offsets are going to be magic numbers, im too lazy to set these as macros
        iowrite32(prev_value, axi_pckt_gen + OFFSET_DEST_MAC_2_HIGH);

        break;
    
    case 3:
        // Write lower part of dest_MAC_0
        iowrite32((u32)mac, axi_pckt_gen + OFFSET_DEST_MAC_3_LOW);

        //Writes upper part of dest_MAC_0
        prev_value = ioread32(axi_pckt_gen + OFFSET_DEST_MAC_3_HIGH);
        prev_value = (prev_value & 0x0000FFFF) | ((u32)(mac >> 16)& 0xFFFF0000); // these offsets are going to be magic numbers, im too lazy to set these as macros
        iowrite32(prev_value, axi_pckt_gen + OFFSET_DEST_MAC_3_HIGH);

        break;
    
    
    default:
        return -BAD_CHANNEL;
        break;
    }
    return 0;
}

int src_mac_config(u64 mac, u8 chn){
    // Reading the content of the mode_registers to apply mask in writing
    u32 prev_value = 0;
    
    switch (chn)
    {
    case 0:
        // Write lower part of dest_MAC_0
        iowrite32((u32)mac, axi_pckt_gen + OFFSET_SRC_MAC_0_LOW);

        //Writes upper part of dest_MAC_0
        prev_value = ioread32(axi_pckt_gen + OFFSET_SRC_MAC_0_HIGH);
        prev_value = (prev_value & 0xFFFF0000) | (u32)(mac >> 32);
        iowrite32(prev_value, axi_pckt_gen + OFFSET_SRC_MAC_0_HIGH);
        break;
    
    case 1:
        // Write lower part of dest_MAC_0
        iowrite32((u32)mac, axi_pckt_gen + OFFSET_SRC_MAC_1_LOW);

        //Writes upper part of dest_MAC_0
        prev_value = ioread32(axi_pckt_gen + OFFSET_SRC_MAC_1_HIGH);
        prev_value = (prev_value & 0x0000FFFF) | ((u32)(mac >> 16)& 0xFFFF0000); // these offsets are going to be magic numbers, im too lazy to set these as macros
        iowrite32(prev_value, axi_pckt_gen + OFFSET_SRC_MAC_1_HIGH);
        break;

    case 2:
        // Write lower part of dest_MAC_0
        iowrite32((u32)mac, axi_pckt_gen + OFFSET_SRC_MAC_2_LOW);

        //Writes upper part of dest_MAC_0
        prev_value = ioread32(axi_pckt_gen + OFFSET_SRC_MAC_2_HIGH);
        prev_value = (prev_value & 0xFFFF0000) | (u32)(mac >> 32); // these offsets are going to be magic numbers, im too lazy to set these as macros
        iowrite32(prev_value, axi_pckt_gen + OFFSET_SRC_MAC_2_HIGH);

        break;
    
    case 3:
        // Write lower part of dest_MAC_0
        iowrite32((u32)mac, axi_pckt_gen + OFFSET_SRC_MAC_3_LOW);

        //Writes upper part of dest_MAC_0
        prev_value = ioread32(axi_pckt_gen + OFFSET_SRC_MAC_3_HIGH);
        prev_value = (prev_value & 0x0000FFFF) | ((u32)(mac >> 16)& 0xFFFF0000); // these offsets are going to be magic numbers, im too lazy to set these as macros
        iowrite32(prev_value, axi_pckt_gen + OFFSET_SRC_MAC_3_HIGH);

        break;
    
    
    default:
        return -BAD_CHANNEL;
        break;
    }
    return 0;
}

int set_payload_pattern(u32 pattern, u8 chn){
    u8 offset = 0;

    switch (chn)
    {
    case 0:
        offset = PATTERN_OFFSET_0;
        break;
    case 1:
        offset = PATTERN_OFFSET_1;
        break;
    case 2:
        offset = PATTERN_OFFSET_2;
        break;
    case 3:
        offset = PATTERN_OFFSET_3;
        break;
    
    default:
        break;
    }
    iowrite32(pattern, axi_pckt_gen+ offset);
	return 0;
}

int set_payload_length(u16 len, u8 chn){
    u32 prev_value = 0;

    if(len < MIN_PCKT_LEN) len = MIN_PCKT_LEN;
    if(len > MAX_PCKT_LEN) len = MAX_PCKT_LEN; 

    switch (chn)
    {
    case 0:
        prev_value = ioread32(axi_pckt_gen + OFFSET_PKT_LEN_0);
        prev_value = (prev_value & 0xFFFF0000) | ((u32)(len) & 0x0000FFFF);
        iowrite32(prev_value, axi_pckt_gen + OFFSET_PKT_LEN_0);
        break;
    case 1:
        prev_value = ioread32(axi_pckt_gen + OFFSET_PKT_LEN_1);
        prev_value = (prev_value & 0x0000FFFF) | (((u32)(len) << 16 ) & 0xFFFF0000);
        iowrite32(prev_value, axi_pckt_gen + OFFSET_PKT_LEN_1);
        break;
    case 2:
        prev_value = ioread32(axi_pckt_gen + OFFSET_PKT_LEN_2);
        prev_value = (prev_value & 0xFFFF0000) | ((u32)(len) & 0x0000FFFF);
        iowrite32(prev_value, axi_pckt_gen + OFFSET_PKT_LEN_2);
        break;
    case 3:
        prev_value = ioread32(axi_pckt_gen + OFFSET_PKT_LEN_3);
        prev_value = (prev_value & 0x0000FFFF) | (((u32)(len) << 16 ) & 0xFFFF0000);
        iowrite32(prev_value, axi_pckt_gen + OFFSET_PKT_LEN_3);
        break;
    
    default:
        return -BAD_CHANNEL;
        break;
    }

    return 0;
}

int set_enable(u8 flags){
    u32 prev_value = 0;
    prev_value = ((ioread32(axi_pckt_gen) & 0xFFFFFFF0) | (u32) flags);
    iowrite32(prev_value, axi_pckt_gen);
    return 0;
}

int set_capture_flags(u8 flags){
    u32 prev_value = 0;
    prev_value = ((ioread32(axi_pckt_gen) & 0xFFF0FFFF) | (u32) flags << 16);
    iowrite32(prev_value, axi_pckt_gen);
    return 0;
}


int configure_ETH_MAC(u8 eth_channel_flag, u8 loopback_flag){
    int i;
    for (i = 0; i < 4; i++){
        if ((eth_channel_flag & (1 << i)) != 0){
            if ((loopback_flag & (1 << i)) != 0)
            iowrite32(0xC0000000 , axi_eth_channels[i] + 0x08);
            else
            iowrite32(0x40000000 , axi_eth_channels[i] + 0x08);

            iowrite32(0x00003003 , axi_eth_channels[i] + 0x0C);
            iowrite32(0x00000033 , axi_eth_channels[i] + 0x14);
            iowrite32(0x00000001 , axi_eth_channels[i] + 0x00);
            iowrite32(0x00000001 , axi_eth_channels[i] + 0x20);
        }
	
    }
    return 0;
}

int gen_mode_config(u8 mode, u32 param, u8 chn){
    u8  offset;
    u32 mode_reg = ioread32(axi_pckt_gen + OFFSET_MODE_REG);
    switch (chn)
    {
    case 0:
        //Writes generation mode of channel 0
        mode_reg = (MASK_GEN_MODE_0 & mode_reg) | (u32)mode << 4;
        iowrite32(mode_reg, axi_pckt_gen + OFFSET_MODE_REG);
        offset = CHN_0_PARAM_OFF;
        break;
    
    case 1:
        //Writes generation mode of channel 1
        mode_reg = (MASK_GEN_MODE_1 & mode_reg) | (u32)mode << 7;
        iowrite32(mode_reg, axi_pckt_gen + OFFSET_MODE_REG);
        offset = CHN_1_PARAM_OFF;
        break;
    
    case 2:
        //Writes generation mode of channel 2
        mode_reg = (MASK_GEN_MODE_2 & mode_reg) | (u32)mode << 10;
        iowrite32(mode_reg, axi_pckt_gen + OFFSET_MODE_REG);
        offset = CHN_2_PARAM_OFF;
        break;
    
    case 3:
        //Writes generation mode of channel 2
        mode_reg = (MASK_GEN_MODE_3 & mode_reg) | (u32)mode << 13;
        iowrite32(mode_reg, axi_pckt_gen + OFFSET_MODE_REG);
        offset = CHN_3_PARAM_OFF;
        break;
    
    default:
        return -BAD_CHANNEL;
        break;
    }

    iowrite32(param, axi_pckt_gen + offset);

    return 0;
}

int gen_mode_burst(u16 pckts_per_burst, u16 cycles_per_halt, u8 chn){
    u32 mode_reg = ioread32(axi_pckt_gen + OFFSET_MODE_REG);
    u8 off;
    
    switch (chn)
    {
    case 0:
        mode_reg = (MASK_GEN_MODE_3 & mode_reg) | (u32)GM_BURST << 4; 
        off = CHN_0_PARAM_OFF;
        break;

    case 1:
        mode_reg = (MASK_GEN_MODE_3 & mode_reg) | (u32)GM_BURST << 7; 
        off = CHN_1_PARAM_OFF;
        break;

    case 2:
        mode_reg = (MASK_GEN_MODE_3 & mode_reg) | (u32)GM_BURST << 10; 
        off= CHN_2_PARAM_OFF;
        break;

    case 3:
        mode_reg = (MASK_GEN_MODE_3 & mode_reg) | (u32)GM_BURST << 13; 
        off= CHN_3_PARAM_OFF;
        break;
    
    default:
        return -BAD_CHANNEL;
        break;
    }
    
    iowrite32(mode_reg, axi_pckt_gen + OFFSET_MODE_REG);
    iowrite32(((u32)pckts_per_burst << 16)|((0x0000FFFF) & (u32) cycles_per_halt), axi_pckt_gen + off);
    return 0;
}

int set_pcktgen_config(config_pckt_gen param){

    configure_ETH_MAC(param.enable_flg,param.loopback_flg); 
    
    dest_mac_config(param.dest_mac, param.trgt_chn);
    if(param.gen_mode == 3){
        gen_mode_burst(30, 600, param.trgt_chn);
    } else
        gen_mode_config(param.gen_mode, param.gen_mode_param, param.trgt_chn);

    src_mac_config(param.src_mac, param.trgt_chn);
    set_payload_pattern(param.payload_pattern, param.trgt_chn);
    set_payload_length(param.pckt_len, param.trgt_chn);
    
    return 0;
}

MODULE_LICENSE("GPL");


module_init(init_driver);
module_exit(exit_driver);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Antonio Morales");
MODULE_DESCRIPTION("Ethernet Generator/Analyzer driver.");

u32 stats_read(s8 chn, u8 packet_or_byte){
    u8 offset = 0;

    

    switch(chn){
        case 1:
            offset = STATS_TX0;
            break;
        case 2:
            offset = STATS_TX1;
            break;
        case 3:
            offset = STATS_TX2;
            break;
        case 4:
            offset = STATS_TX3;
            break;
        case -1:
            offset = STATS_RX0;
            break;
        case -2:
            offset = STATS_RX1;
            break;
        case -3:
            offset = STATS_RX2;
            break;
        case -4:
            offset = STATS_RX3;
            break;
    }

    if(packet_or_byte)
        offset+=0x04;

    return ioread32(axi_pckt_gen + offset);
}