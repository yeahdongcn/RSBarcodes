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
        self.length = 13;
    }
    return self;
}

- (NSString *)barcode:(NSString *)contents
{
    NSMutableString *barcode = [[NSMutableString alloc] initWithString:@""];
    NSString *parityEncodingTable = self.types[[[contents substringToIndex:1] intValue]];
    for (int i = 1; i < self.length; i++) {
        int digit = [[contents substringWithRange:NSMakeRange(i, 1)] intValue];
        if (i <= parityEncodingTable.length) {
            [barcode appendString:[NSString stringWithFormat:@"%@", self.map[digit][[parityEncodingTable substringWithRange:NSMakeRange(i - 1, 1)]]]];
            if (i == parityEncodingTable.length) {
                [barcode appendString:[self centerGuardPattern]];
            }
        } else {
            [barcode appendString:[NSString stringWithFormat:@"%@", self.map[digit][@"R"]]];
        }
    }
    return [NSString stringWithString:barcode];
}

@end
