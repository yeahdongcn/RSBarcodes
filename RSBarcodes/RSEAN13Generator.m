//
//  RSEAN13Generator.m
//  RSBarcodes
//
//  Created by zhangxi on 13-12-26.
//  http://zhangxi.me
//  Copyright (c) 2013年 P.D.Q. All rights reserved.
//

#import "RSEAN13Generator.h"

@implementation RSEAN13Generator

- (id)init
{
    self = [super init];
    if (self) {
        length = 13;
    }
    return self;
}

- (NSString *)barcode:(NSString *)contents
{
    NSString *code = @"";
    
    NSString *firstChar = [contents substringToIndex:1];
    NSString *codeType = codeTypes[[firstChar intValue]];
    
    for (int i = 0; i < (length - 1); i++) {
        int value = [[contents substringWithRange:NSMakeRange(i + 1, 1)] intValue];
        NSString *type;
        if (i <= (length / 2 - 1)) {
            type = [codeType substringWithRange:NSMakeRange(i, 1)];
        } else {
            type = @"C";
        }
        
        code = [code stringByAppendingFormat:@"%@",codeMap[value][type]];
        
        //中线
        if (i == (length / 2 - 1)) {
            code = [code stringByAppendingString:@"01010"];
        }
    }
    
    return code;
}

@end
