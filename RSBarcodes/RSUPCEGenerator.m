//
//  RSUPCEGenerator.m
//  RSBarcodes
//
//  Created by R0CKSTAR on 12/27/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "RSUPCEGenerator.h"

@implementation RSUPCEGenerator

static NSString *const UPCE_ODD_ENCODINGS[10] = {
    @"0001101", @"0011001", @"0010011", @"0111101", @"0100011",
    @"0110001", @"0101111", @"0111011", @"0110111", @"0001011"};

static NSString *const UPCE_EVEN_ENCODINGS[10] = {
    @"0100111", @"0110011", @"0011011", @"0100001", @"0011101",
    @"0111001", @"0000101", @"0010001", @"0001001", @"0010111"};

static NSString *const UPCE_SEQUENCES[10] = {
    @"000111", @"001011", @"001101", @"001110", @"010011",
    @"011001", @"011100", @"010101", @"010110", @"011010"};

- (NSString *)convert2UPC_A:(NSString *)upc_e {
    NSString *code = [upc_e substringWithRange:NSMakeRange(1, upc_e.length - 2)];
    int lastDigit =
    [[code substringWithRange:NSMakeRange(code.length - 1, 1)] intValue];
    NSString *insertDigits = @"0000";
    NSMutableString *upc_a = [[NSMutableString alloc] init];
    switch (lastDigit) {
        case 0:
        case 1:
        case 2:
            [upc_a appendString:[code substringWithRange:NSMakeRange(0, 2)]];
            [upc_a appendString:[NSString stringWithFormat:@"%d", lastDigit]];
            [upc_a appendString:insertDigits];
            [upc_a appendString:[code substringWithRange:NSMakeRange(2, 3)]];
            break;
        case 3:
            insertDigits = @"00000";
            [upc_a appendString:[code substringWithRange:NSMakeRange(0, 3)]];
            [upc_a appendString:insertDigits];
            [upc_a appendString:[code substringWithRange:NSMakeRange(3, 2)]];
            break;
        case 4:
            insertDigits = @"00000";
            [upc_a appendString:[code substringWithRange:NSMakeRange(0, 4)]];
            [upc_a appendString:insertDigits];
            [upc_a appendString:[code substringWithRange:NSMakeRange(4, 1)]];
            break;
        default:
            [upc_a appendString:[code substringWithRange:NSMakeRange(0, 5)]];
            [upc_a appendString:insertDigits];
            [upc_a appendString:[NSString stringWithFormat:@"%d", lastDigit]];
            break;
    }
    return [NSString stringWithFormat:@"%@%@", @"00", upc_a];
}

- (BOOL)isContentsValid:(NSString *)contents {
    if ([super isContentsValid:contents] &&
        [self respondsToSelector:@selector(checkDigit:)]) {
        if (contents.length == 8 &&
            [[contents substringWithRange:NSMakeRange(0, 1)] intValue] == 0 &&
            [[contents substringWithRange:NSMakeRange(contents.length - 1, 1)]
             isEqualToString:[self checkDigit:contents]]) {
                return YES;
            }
    }
    return NO;
}

- (NSString *)initiator {
    return @"101";
}

- (NSString *)terminator {
    return @"010101";
}

- (NSString *)barcode:(NSString *)contents {
    int checkValue = [[contents
                       substringWithRange:NSMakeRange(contents.length - 1, 1)] intValue];
    NSString *sequence = UPCE_SEQUENCES[checkValue];
    NSMutableString *barcode = [[NSMutableString alloc] initWithString:@""];
    for (int i = 1; i < (contents.length - 1); i++) {
        int digit = [[contents substringWithRange:NSMakeRange(i, 1)] intValue];
        if ([[sequence substringWithRange:NSMakeRange((i - 1), 1)] intValue] % 2 ==
            0) {
            [barcode appendString:UPCE_EVEN_ENCODINGS[digit]];
        } else {
            [barcode appendString:UPCE_ODD_ENCODINGS[digit]];
        }
    }
    return [NSString stringWithString:barcode];
}

#pragma mark - RSCheckDigitGenerator

- (NSString *)checkDigit:(NSString *)contents {
    //    UPC-A check digit is calculated using standard Mod10 method. Here
    // outlines the steps to calculate UPC-A check digit:
    //
    //    From the right to left, start with odd position, assign the odd/even
    // position to each digit.
    //    Sum all digits in odd position and multiply the result by 3.
    //    Sum all digits in even position.
    //    Sum the results of step 3 and step 4.
    //    divide the result of step 4 by 10. The check digit is the number which
    // adds the remainder to 10.
    NSString *upc_a = [self convert2UPC_A:contents];
    int sum_odd = 0;
    int sum_even = 0;
    for (int i = 0; i < upc_a.length; i++) {
        int digit = [[upc_a substringWithRange:NSMakeRange(i, 1)] intValue];
        if (i % 2 == 0) {
            sum_even += digit;
        } else {
            sum_odd += digit;
        }
    }
    return [NSString stringWithFormat:@"%d", 10 - (sum_even + sum_odd * 3) % 10];
}

@end
