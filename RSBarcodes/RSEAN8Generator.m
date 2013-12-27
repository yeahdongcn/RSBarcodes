//
//  RSEAN8Generator.m
//  RSBarcodesSample
//
//  Created by zhangxi on 13-12-26.
//  Copyright (c) 2013年 P.D.Q. All rights reserved.
//

#import "RSEAN8Generator.h"

@implementation RSEAN8Generator

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
    int oddCount  = 0;
    int evenCount = 0;
    
    //左资料
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
    
    
    for(int i=0;i<8;i++)
    {
        int value = [[contents substringWithRange:NSMakeRange(i, 1)] intValue];
        
        NSString *type;
        if(i<=3)
        {
            type = [codeType substringWithRange:NSMakeRange(i, 1)];
        }else
        {
            type = @"C";
        }
        NSLog(@"%d %@",value,type);
        code = [code stringByAppendingFormat:@"%@",codeMap[value][type]];
        
        //中线
        if(i==3)
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
