#import <Foundation/Foundation.h>
#import "myheader.h"

@interface MyObjectiveCInterface()

+(NSString *)getKey;
+(NSString *)getSecret;

@end

@implementation MyObjectiveCInterface

+(NSString *)getKey
{

    const unsigned char _key[] = { 0x72, 0xB, 0x3C, 0x34, 0xA, 0x60, 0x67, 0x58, 0x78, 0xA, 0x60, 0x78, 0x71, 0x60, 0x7F, 0x5C, 0x48, 0x7, 0x75, 0x56, 0x21, 0x1A, 0x59, 0x51, 0x54, 0x00 };
    const unsigned char *key = &_key[0];
    
    NSString *string = [NSString stringWithUTF8String: key];
    
    return string;
}

+(NSString *)getSecret
{
    const unsigned char _key[] = { 0x2, 0x6A, 0x27, 0x15, 0x21, 0xC, 0x5A, 0x6D, 0x6E, 0x3, 0x41, 0x47, 0x3, 0x2, 0x5, 0x5B, 0x5C, 0xD, 0x74, 0x3D, 0x2F, 0x16, 0x57, 0x10, 0x65, 0x71, 0x7C, 0x3C, 0x7E, 0x60, 0x36, 0x5F, 0x66, 0x55, 0x6, 0x68, 0x60, 0x19, 0x3E, 0x64, 0x75, 0x55, 0x14, 0x2E, 0x21, 0x78, 0x50, 0x6D, 0x63, 0x25, 0x00 };
    const unsigned char *key = &_key[0];
    
    NSString *string = [NSString stringWithUTF8String: key];
    
    return string;
}

@end