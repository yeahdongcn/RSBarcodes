//
//  RSEANGenerator.m
//  RSBarcodes
//
//  Created by zhangxi on 14-1-6.
//  http://zhangxi.me
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

#import "RSEANGenerator.h"

@implementation RSEANGenerator

- (id)init
{
    self = [super init];
    if (self) {
        codeTypes = @[@"AAAAAA",@"AAAAAA",@"AABABB",@"AABBAB",@"ABAABB",@"ABBAAB",@"ABBBAA",@"ABABAB",@"ABABBA",@"ABBABA"];
        
        codeMap = @[@{@"A":@"0001101",@"B":@"0100111",@"C":@"1110010"},
                    @{@"A":@"0011001",@"B":@"0110011",@"C":@"1100110"},
                    @{@"A":@"0010011",@"B":@"0011011",@"C":@"1101100"},
                    @{@"A":@"0111101",@"B":@"0100001",@"C":@"1000010"},
                    @{@"A":@"0100011",@"B":@"0011101",@"C":@"1011100"},
                    @{@"A":@"0110001",@"B":@"0111001",@"C":@"1001110"},
                    @{@"A":@"0101111",@"B":@"0000101",@"C":@"1010000"},
                    @{@"A":@"0111011",@"B":@"0010001",@"C":@"1000100"},
                    @{@"A":@"0110111",@"B":@"0001001",@"C":@"1001000"},
                    @{@"A":@"0001011",@"B":@"0010111",@"C":@"1110100"}];
    }
    return self;
}

- (BOOL)isContentsValid:(NSString *)contents
{
    //机选是否是纯数字
    BOOL isNumber = [super isContentsValid:contents];
    if (!isNumber) return NO;
    
    //计算长度 == length
    if (contents.length != length) return NO;
    
    //计算较验位
    int oddCount  = 0;
    int evenCount = 0;
    
    for (int i = 0; i < (length - 1); i++) {
        int value = [[contents substringWithRange:NSMakeRange(i, 1)] intValue];
        if ((i + 1) % 2 == 1) {
            oddCount += value;
        } else {
            evenCount += value;
        }
    }
    int checkCode = 10 - ((oddCount + evenCount * 3) % 10);
    checkCode %= 10;
    
    //是否与最后一位相等
    return [[contents substringFromIndex:contents.length - 1] intValue] == checkCode;
}

- (NSString *)initiator
{
    return @"0000000101";
}

- (NSString *)terminator
{
    return @"1010000000";
}

@end
