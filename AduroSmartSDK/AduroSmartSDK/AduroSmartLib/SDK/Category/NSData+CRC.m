//
//  NSData+CRC.m
//  AduroSmartFrameWork
//
//  Created by MacBook on 2017/4/12.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "NSData+CRC.h"

@implementation NSData (CRC)
+(unsigned short)crc16:(NSData *)data
{
    const uint8_t *bytes = (const uint8_t *)[data bytes];
    uint16_t length = (uint16_t)[data length];
    return (unsigned short)gen_crc16(bytes, length);
}


#define CRC16 0x8005

uint16_t gen_crc16(const uint8_t *data, uint16_t size)
{
    uint16_t out = 0;
    int bits_read = 0, bit_flag;
    
    if(data == NULL)
        return 0;
    
    while(size > 0)
    {
        bit_flag = out >> 15;
        
        out <<= 1;
        out |= (*data >> bits_read) & 1;
        
        bits_read++;
        if(bits_read > 7)
        {
            bits_read = 0;
            data++;
            size--;
        }
        
        if(bit_flag)
            out ^= CRC16;
        
    }
    
    int i;
    for (i = 0; i < 16; ++i) {
        bit_flag = out >> 15;
        out <<= 1;
        if(bit_flag)
            out ^= CRC16;
    }
    
    uint16_t crc = 0;
    i = 0x8000;
    int j = 0x0001;
    for (; i != 0; i >>=1, j <<= 1) {
        if (i & out) crc |= j;
    }
    
    return crc;
    
}

+(unsigned short)crc8:(NSData *)data
{
    const uint8_t *bytes = (const uint8_t *)[data bytes];
    uint16_t length = (uint16_t)[data length];
    return (unsigned short)gen_crc8(bytes, length);
}

uint16_t gen_crc8(const uint8_t *data, uint16_t size)
{
    uint16_t out = 0;
    return f_crc8(out, data, size);
}


uint8_t f_crc8(uint8_t  crc_val,const uint8_t *buf,uint32_t len)
{
    uint32_t l=0;
    uint8_t i, crc;
    uint16_t init=0;
    
    init=crc_val*0x100;
    for(l=0;l<len;l++)
    {
        init^=(buf[l]*0x100);
        for(i=0;i<8;i++)
        {
            if(init&0x8000)
                init^=0x8380;
            init*=2;
        }
    }
    crc = init/0x100;
    return crc;
}

@end
