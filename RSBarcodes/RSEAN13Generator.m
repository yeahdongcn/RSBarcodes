//
//  RSEAN13Generator.m
//  RSBarcodesSample
//
//  Created by zhangxi on 13-12-26.
//  Copyright (c) 2013年 P.D.Q. All rights reserved.
//



#import "RSEAN13Generator.h"

@implementation RSEAN13Generator


- (BOOL)isContentsValid:(NSString *)contents
{
    //机选是否是纯数字
    BOOL isNumber = [super isContentsValid:contents];
    if(isNumber == NO) return NO;

    //计算长度 ==13
    if(contents.length != 13) return NO;
    
    
    //计算较验位
    int oddCount  = 0;
    int evenCount = 0;
    
    for(int i=0;i<12;i++)
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
    return @"00000000000101";
}

- (NSString *)terminator
{
    return @"1010000000";
}

- (NSString *)barcode:(NSString *)contents
{
    NSLog(@"%@",[self isContentsValid:contents]?@"yes":@"no");
    
    NSString *code = @"";
    
    NSString *firstChar = [contents substringToIndex:1];
    NSString *codeType = codeTypes[[firstChar intValue]];
    
    
    for(int i=0;i<12;i++)
    {
        int value = [[contents substringWithRange:NSMakeRange(i+1, 1)] intValue];
        
        NSString *type;
        if(i<=5)
        {
            type = [codeType substringWithRange:NSMakeRange(i, 1)];
        }else
        {
            type = @"C";
        }

        code = [code stringByAppendingFormat:@"%@",codeMap[value][type]];
        
        //中线
        if(i==5)
        {
            code = [code stringByAppendingString:@"01010"];
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
