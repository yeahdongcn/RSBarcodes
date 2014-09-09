//
//  RSISSN13Generator.m
//  RSBarcodes
//
//  Created by R0CKSTAR on 14-1-18.
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

#import "RSISSN13Generator.h"

NSString *const RSMetadataObjectTypeISSN13Code = @"com.pdq.rsbarcodes.issn13";

@implementation RSISSN13Generator

- (BOOL)isContentsValid:(NSString *)contents {
    // http://www.appsbarcode.com/ISSN.php
    return [super isContentsValid:contents] &&
    [[contents substringToIndex:3] isEqualToString:@"977"];
}

@end
