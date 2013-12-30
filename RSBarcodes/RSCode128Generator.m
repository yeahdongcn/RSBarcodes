//
//  RSCode128Generator.m
//  RSBarcodesSample
//
//  Created by R0CKSTAR on 12/30/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "RSCode128Generator.h"

@interface RSCode128Generator ()

@end

@implementation RSCode128Generator

- (BOOL)isContentsValid:(NSString *)contents
{
    return contents.length > 0 ? YES : NO;
}

#pragma mark - RSCheckDigitGenerator

- (NSString *)checkDigit:(NSString *)contents
{
    return @"";
}

@end
