//
//  NSData+AES128.m
//  AduroSmartFrameWork
//
//  Created by MacBook on 2017/4/12.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import "NSData+AES128.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>

const CCAlgorithm kAESAlgorithm = kCCAlgorithmAES;
const CCOptions kAESAlgorithmOption = kCCOptionPKCS7Padding;
const NSUInteger kAESAlgorithmKeySize = kCCKeySizeAES128;
const NSUInteger kAESAlgorithmBlockSize = kCCBlockSizeAES128;
const NSUInteger kAESAlgorithmIVSize = kCCBlockSizeAES128;

@implementation NSData(AES128)

+ (NSData *)encrypt:(NSData *)data withKey:(NSData *)key
{
    return [self encrypt:data withKey:key withIV:nil];
}

+ (NSData *)encrypt:(NSData *)data withKey:(NSData *)key withIV:(NSData *)iv
{
    size_t outLength;
    NSMutableData *cipherData = [NSMutableData dataWithLength:data.length + kAESAlgorithmBlockSize];
    CCCryptorStatus result = CCCrypt(kCCEncrypt, // operation
                                     kAESAlgorithm, // Algorithm
                                     kAESAlgorithmOption, // options
                                     key.bytes, // key
                                     key.length, // keylength
                                     0,// iv
                                     data.bytes, // dataIn
                                     data.length, // dataInLength,
                                     cipherData.mutableBytes, // dataOut
                                     cipherData.length, // dataOutAvailable
                                     &outLength); // dataOutMoved
    
    if (result == kCCSuccess) {
        cipherData.length = outLength;
    }
    return cipherData;
}

+ (NSData *)decrypt:(NSData *)data withKey:(NSData *)key
{
    NSLog(@"decrypt ==== %@,key === %@",data,key);
    return [self decrypt:data withKey:key withIV:nil];
}

+ (NSData *)decrypt:(NSData *)data withKey:(NSData *)key withIV:(NSData *)iv
{
    size_t outLength;
    NSMutableData *cipherData = [NSMutableData dataWithLength:data.length + kAESAlgorithmBlockSize];
    
    CCCryptorStatus result = CCCrypt(kCCDecrypt, // operation
                                     kAESAlgorithm, // Algorithm
                                     kAESAlgorithmOption, // options
                                     key.bytes, // key
                                     key.length, // keylength
                                     (iv).bytes,// iv
                                     data.bytes, // dataIn
                                     data.length, // dataInLength,
                                     cipherData.mutableBytes, // dataOut
                                     cipherData.length, // dataOutAvailable
                                     &outLength); // dataOutMoved
    
    if (result == kCCSuccess) {
        cipherData.length = outLength;
    }
    
    return cipherData;
}


+ (NSData *)randomDataOfLength:(size_t)length {
    NSMutableData *data = [NSMutableData dataWithLength:length];
    
    int result = SecRandomCopyBytes(kSecRandomDefault,
                                    length,
                                    data.mutableBytes);
    NSAssert(result == 0, @"Unable to generate random bytes: %d",
             errno);
    
    return data;
}

@end
