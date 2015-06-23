//
//  RSCode93Generator.m
//  RSBarcodes
//
//  Created by R0CKSTAR on 12/30/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "RSCode93Generator.h"

static NSString *const CODE93_ALPHABET_STRING = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%abcd*";

static NSString *const CODE93_PLACEHOLDER_STRING = @"abcd";

static NSString *const CODE93_CHARACTER_ENCODINGS[48] = {
    @"100010100", @"101001000", @"101000100", @"101000010", @"100101000",
    @"100100100", @"100100010", @"101010000", @"100010010", @"100001010",
    @"110101000", @"110100100", @"110100010", @"110010100", @"110010010",
    @"110001010", @"101101000", @"101100100", @"101100010", @"100110100",
    @"100011010", @"101011000", @"101001100", @"101000110", @"100101100",
    @"100010110", @"110110100", @"110110010", @"110101100", @"110100110",
    @"110010110", @"110011010", @"101101100", @"101100110", @"100110110",
    @"100111010", @"100101110", @"111010100", @"111010010", @"111001010",
    @"101101110", @"101110110", @"110101110", @"100100110", @"111011010",
    @"111010110", @"100110010", @"101011110"};

@implementation RSCode93Generator

- (NSString *)__encodeCharacter:(NSString *)character {
    return CODE93_CHARACTER_ENCODINGS[
                                      [CODE93_ALPHABET_STRING rangeOfString:character].location];
}

- (BOOL)isContentsValid:(NSString *)contents {
    if (contents.length > 0 &&
        [contents isEqualToString:[contents uppercaseString]]) {
        for (int i = 0; i < contents.length; i++) {
            if ([CODE93_ALPHABET_STRING
                 rangeOfString:[contents substringWithRange:NSMakeRange(i, 1)]]
                .location == NSNotFound) {
                return NO;
            }
            if ([CODE93_PLACEHOLDER_STRING
                 rangeOfString:[contents substringWithRange:NSMakeRange(i, 1)]]
                .location != NSNotFound) {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

- (NSString *)initiator {
    return [self __encodeCharacter:@"*"];
}

- (NSString *)terminator {
    // With the termination bar: 1
    return
    [NSString stringWithFormat:@"%@%@", [self __encodeCharacter:@"*"], @"1"];
}

- (NSString *)barcode:(NSString *)contents {
    NSMutableString *barcode = [[NSMutableString alloc] initWithString:@""];
    for (int i = 0; i < contents.length; i++) {
        [barcode
         appendString:[self __encodeCharacter:[contents substringWithRange:
                                               NSMakeRange(i, 1)]]];
    }
    if ([self respondsToSelector:@selector(checkDigit:)]) {
        NSString *checkDigits = [self checkDigit:contents];
        for (int i = 0; i < checkDigits.length; i++) {
            [barcode
             appendString:[self __encodeCharacter:
                           [checkDigits
                            substringWithRange:NSMakeRange(i, 1)]]];
        }
    }
    return [NSString stringWithString:barcode];
}

#pragma mark - RSCheckDigitGenerator

- (NSString *)checkDigit:(NSString *)contents {
    // Weighted sum += value * weight
    
    // The first character
    int sum = 0;
    for (int i = 0; i < contents.length; i++) {
        NSString *character = [contents substringWithRange:NSMakeRange(contents.length - i - 1, 1)];
        NSUInteger characterValue =
        [CODE93_ALPHABET_STRING rangeOfString:character].location;
        sum += characterValue * (i % 20 + 1);
    }
    NSMutableString *checkDigits = [[NSMutableString alloc] init];
    [checkDigits appendString:[CODE93_ALPHABET_STRING
                               substringWithRange:NSMakeRange(sum % 47, 1)]];
    
    // The second character
    sum = 0;
    NSString *newContents =
    [NSString stringWithFormat:@"%@%@", contents, checkDigits];
    for (int i = 0; i < newContents.length; i++) {
        NSString *character = [newContents substringWithRange:NSMakeRange(newContents.length - i - 1, 1)];
        NSUInteger characterValue =
        [CODE93_ALPHABET_STRING rangeOfString:character].location;
        sum += characterValue * (i % 15 + 1);
    }
    [checkDigits appendString:[CODE93_ALPHABET_STRING
                               substringWithRange:NSMakeRange(sum % 47, 1)]];
    return [NSString stringWithString:checkDigits];
}

@end
