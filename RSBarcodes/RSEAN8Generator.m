//
//  RSEAN8Generator.m
//  RSBarcodesSample
//
//  Created by zhangxi on 13-12-26.
//  Copyright (c) 2013年 P.D.Q. All rights reserved.
//

#import "RSEAN8Generator.h"

@implementation RSEAN8Generator


- (BOOL)isContentsValid:(NSString *)contents
{
    //机选是否是纯数字
    BOOL isNumber = [super isContentsValid:contents];
    if(isNumber == NO) return NO;
    
    //计算长度 ==13
    if(contents.length != 8) return NO;
    
    
    //计算较验位
    int oddCount  = 0;
    int evenCount = 0;
    
    for(int i=0;i<7;i++)
    {
        int value = [[contents substringWithRange:NSMakeRange(i, 1)] intValue];
        if((i+1)%2 == 1)
        {
            oddCount += value;
            
        }else
        {
            evenCount += value;
        }
    }
    int checkCode = 10-((oddCount+evenCount*3)%10);
    checkCode %= 10;
    
    //是否与最后一位相等
    return [[contents substringFromIndex:contents.length-1] intValue] == checkCode;
}


- (NSString *)initiator
{
    return @"0000000101";
}

- (NSString *)terminator
{
    return @"1010000000";
}

- (NSString *)barcode:(NSString *)contents
{
    NSString *code = @"";
    
    for(int i=0;i<8;i++)
    {
        int value = [[contents substringWithRange:NSMakeRange(i, 1)] intValue];
        
        if(i <= 3)
        {
            code = [code stringByAppendingFormat:@"%@",codeMap[value][@"A"]];
            if (i == 3)
                code = [code stringByAppendingString:@"01010"];
        }else
        {
            code = [code stringByAppendingFormat:@"%@",codeMap[value][@"C"]];
        }
    }
    return code;
}

- (NSString *)completeBarcode:(NSString *)barcode
{
    
    if (![barcode isEqualToString:@""]) {
        return [NSString stringWithFormat:@"%@%@%@", [self initiator], barcode, [self terminator]];
    }
    return nil;
}

@end
