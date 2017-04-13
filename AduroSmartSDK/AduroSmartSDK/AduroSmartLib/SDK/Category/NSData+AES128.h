//
//  NSData+AES128.h
//  AduroSmartFrameWork
//
//  Created by MacBook on 2017/4/12.
//  Copyright © 2017年 Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES128)
+ (NSData *)encrypt:(NSData *)data withKey:(NSData *)key;
+ (NSData *)encrypt:(NSData *)data withKey:(NSData *)key withIV:(NSData *)iv;
+ (NSData *)decrypt:(NSData *)data withKey:(NSData *)key;
+ (NSData *)decrypt:(NSData *)data withKey:(NSData *)key withIV:(NSData *)iv;

@end
