#ifndef ETH_GEN_ANA_LIB_H
#define ETH_GEN_ANA_LIB_H

#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/fs.h>
#include <linux/types.h>
#include <linux/io.h>
#include <linux/uaccess.h>
#include <linux/cdev.h>
#include <linux/device.h>

#define ETH_MAC0_BA 0xA0010000
#define ETH_MAC1_BA 0xA0020000
#define ETH_MAC2_BA 0xA0030000
#define ETH_MAC3_BA 0xA0040000

#define PCKT_GEN_BA 0xA0000000

#define AXI_MAP_SIZE 0x1000


#define CFG_TYPE_PCKT_GEN 0
#define CFG_TYPE_ETH_MAC 1

#define OFFSET_DEST_MAC_0_LOW     0x04
#define OFFSET_DEST_MAC_0_HIGH    0x08
#define OFFSET_DEST_MAC_1_LOW     0x0C
#define OFFSET_DEST_MAC_1_HIGH    0x08
#define OFFSET_DEST_MAC_2_LOW     0x10
#define OFFSET_DEST_MAC_2_HIGH    0x14
#define OFFSET_DEST_MAC_3_LOW     0x18
#define OFFSET_DEST_MAC_3_HIGH    0x14
#define OFFSET_SRC_MAC_0_LOW     0x1C
#define OFFSET_SRC_MAC_0_HIGH    0x20
#define OFFSET_SRC_MAC_1_LOW     0x24
#define OFFSET_SRC_MAC_1_HIGH    0x20
#define OFFSET_SRC_MAC_2_LOW     0x28
#define OFFSET_SRC_MAC_2_HIGH    0x2C
#define OFFSET_SRC_MAC_3_LOW     0x30
#define OFFSET_SRC_MAC_3_HIGH    0x2C
// #define OFFSET_SRC_MAC_LOW      0x1C
// #define OFFSET_SRC_MAC_HIGH     0x20
#define OFFSET_MODE_REG         0x00
#define OFFSET_PCKT_CAPTURE     0x00

#define OFFSET_PKT_LEN_0        0x34
#define OFFSET_PKT_LEN_1        0x34
#define OFFSET_PKT_LEN_2        0x38
#define OFFSET_PKT_LEN_3        0x38

#define MIN_PCKT_LEN 64
#define MAX_PCKT_LEN 1500


#define GM_CONTINUOUS 0
#define GM_NUMB_PCKTS 1
#define GM_NUMB_BYTES 2
#define GM_BURST 	  3

#define MASK_LOWER_16BITS 0x0000FFFF
#define MASK_UPPER_16BITS 0xFFFF0000

#define MASK_GEN_MODE_0 0xFFFFFF8F
#define MASK_GEN_MODE_1 0XFFFFFC7F
#define MASK_GEN_MODE_2 0xFFFFE3FF
#define MASK_GEN_MODE_3 0XFFFF1FFF

#define CHN_0_PARAM_OFF 0x8C
#define CHN_1_PARAM_OFF 0x90
#define CHN_2_PARAM_OFF 0x94
#define CHN_3_PARAM_OFF 0x98

#define PATTERN_OFFSET_0 0x3C
#define PATTERN_OFFSET_1 0x40
#define PATTERN_OFFSET_2 0x44
#define PATTERN_OFFSET_3 0x48

#define STATS_TX0 0x4C
#define STATS_TX1 0x54
#define STATS_TX2 0x5C
#define STATS_TX3 0x64
#define STATS_RX0 0x6C
#define STATS_RX1 0x74
#define STATS_RX2 0x7C
#define STATS_RX3 0x84

//Error codes
#define BAD_CHANNEL 20



#endif