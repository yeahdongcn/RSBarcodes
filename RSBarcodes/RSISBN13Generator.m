//
//  RSISBN13Generator.m
//  RSBarcodes
//
//  Created by R0CKSTAR on 14-1-18.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

#import "RSISBN13Generator.h"

NSString *const RSMetadataObjectTypeISBN13Code = @"com.pdq.rsbarcodes.isbn13";

@implementation RSISBN13Generator

- (BOOL)isContentsValid:(NSString *)contents {
    // http://www.appsbarcode.com/ISBN.php
    return [super isContentsValid:contents] &&
    [[contents substringToIndex:3] isEqualToString:@"978"];
}

@end
