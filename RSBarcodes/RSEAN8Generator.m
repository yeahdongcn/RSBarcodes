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
        self.length = 8;
    }
    return self;
}

- (NSString *)barcode:(NSString *)contents
{
    NSMutableString *barcode = [[NSMutableString alloc] initWithString:@""];
    for (int i = 0; i < self.length; i++) {
        int digit = [[contents substringWithRange:NSMakeRange(i, 1)] intValue];
        if (i <= self.length / 2 - 1) {
            [barcode appendString:[NSString stringWithFormat:@"%@", self.parityEncodingTable[digit][@"O"]]];
            
            if (i == self.length / 2 - 1) {
                [barcode appendString:[self centerGuardPattern]];
            }
        } else {
            [barcode appendString:[NSString stringWithFormat:@"%@", self.parityEncodingTable[digit][@"R"]]];
        }
    }
    return [NSString stringWithString:barcode];
}

@end
