//
//  RSEAN8Generator.m
//  RSBarcodes
//
//  Created by zhangxi on 13-12-26.
//  http://zhangxi.me
//  Copyright (c) 2013年 P.D.Q. All rights reserved.
//

#import "RSEAN8Generator.h"

@implementation RSEAN8Generator

- (id)init
{
    self = [super init];
    if (self) {
        length = 8;
    }
    return self;
}

- (NSString *)barcode:(NSString *)contents
{
    NSString *code = @"";
    
    for (int i = 0; i < length; i++) {
        int value = [[contents substringWithRange:NSMakeRange(i, 1)] intValue];
        
        if (i <= (length / 2 - 1)) {
            code = [code stringByAppendingFormat:@"%@",codeMap[value][@"A"]];
            if (i == (length / 2 - 1)) {
                code = [code stringByAppendingString:@"01010"];
            }
        } else {
            code = [code stringByAppendingFormat:@"%@",codeMap[value][@"C"]];
        }
    }
    return code;
}

@end
