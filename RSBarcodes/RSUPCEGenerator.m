//
//  RSUPCEGenerator.m
//  RSBarcodesSample
//
//  Created by R0CKSTAR on 12/27/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "RSUPCEGenerator.h"

@implementation RSUPCEGenerator

static NSString * const UPCE_ODD_ENCODINGS[10] =  {
    @"0001101",
    @"0011001",
    @"0010011",
    @"0111101",
    @"0100011",
    @"0110001",
    @"0101111",
    @"0111011",
    @"0110111",
    @"0001011"
};

static NSString * const UPCE_EVEN_ENCODINGS[10] = {
    @"0100111",
    @"0110011",
    @"0011011",
    @"0100001",
    @"0011101",
    @"0111001",
    @"0000101",
    @"0010001",
    @"0001001",
    @"0010111"
};

static NSString *const UPCE_SEQUENCES[10] = {
    @"000111",
    @"001011",
    @"001101",
    @"001110",
    @"010011",
    @"011001",
    @"011100",
    @"010101",
    @"010110",
    @"011010"
};

- (BOOL)isContentsValid:(NSString *)contents
{
    if ([super isContentsValid:contents] && [self respondsToSelector:@selector(checkDigit:)]) {
        if (contents.length == 8
            && [[contents substringWithRange:NSMakeRange(0, 1)] intValue] == 0
            && [[contents substringWithRange:NSMakeRange(contents.length - 1, 1)] isEqualToString:[self checkDigit:contents]]) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)initiator
{
    return @"101";
}

- (NSString *)terminator
{
    return @"010101";
}

- (NSString *)barcode:(NSString *)contents
{
    int checkValue = [[contents substringWithRange:NSMakeRange(contents.length - 1, 1)] intValue];
    NSString *sequence = UPCE_SEQUENCES[checkValue];
    NSMutableString *barcode = [[NSMutableString alloc] initWithString:@""];
    for (int i = 1; i < (contents.length - 1); i++) {
        int digit = [[contents substringWithRange:NSMakeRange(i, 1)] intValue];
        if ([[sequence substringWithRange:NSMakeRange((i - 1), 1)] intValue] % 2 == 0) {
            [barcode appendString:UPCE_EVEN_ENCODINGS[digit]];
        } else {
            [barcode appendString:UPCE_ODD_ENCODINGS[digit]];
        }
    }
    return barcode;
}

#pragma mark - RSCheckDigitGenerator

- (NSString *)checkDigit:(NSString *)contents
{
    for (int i = 0; i < contents.length; i++) {
        
    }
    
    return [contents substringWithRange:NSMakeRange(contents.length - 1, 1)];
}

@end
