//
//  RSCode39Generator.m
//  RSBarcodes
//
//  Created by R0CKSTAR on 12/25/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "RSCode39Generator.h"

NSString *const CODE39_ALPHABET_STRING =
@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%*";

static NSString *const CODE39_CHARACTER_ENCODINGS[44] = {
    @"1010011011010", @"1101001010110", @"1011001010110", @"1101100101010",
    @"1010011010110", @"1101001101010", @"1011001101010", @"1010010110110",
    @"1101001011010", @"1011001011010", @"1101010010110", @"1011010010110",
    @"1101101001010", @"1010110010110", @"1101011001010", @"1011011001010",
    @"1010100110110", @"1101010011010", @"1011010011010", @"1010110011010",
    @"1101010100110", @"1011010100110", @"1101101010010", @"1010110100110",
    @"1101011010010", @"1011011010010", @"1010101100110", @"1101010110010",
    @"1011010110010", @"1010110110010", @"1100101010110", @"1001101010110",
    @"1100110101010", @"1001011010110", @"1100101101010", @"1001101101010",
    @"1001010110110", @"1100101011010", @"1001101011010", @"1001001001010",
    @"1001001010010", @"1001010010010", @"1010010010010", @"1001011011010"};

@implementation RSCode39Generator

- (NSString *)__encodeCharacter:(NSString *)character {
    return CODE39_CHARACTER_ENCODINGS[
                                      [CODE39_ALPHABET_STRING rangeOfString:character].location];
}

- (BOOL)isContentsValid:(NSString *)contents {
    if (contents.length > 0 &&
        [contents isEqualToString:[contents uppercaseString]]) {
        for (int i = 0; i < contents.length; i++) {
            if ([CODE39_ALPHABET_STRING
                 rangeOfString:[contents substringWithRange:NSMakeRange(i, 1)]]
                .location == NSNotFound) {
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
    return [self __encodeCharacter:@"*"];
}

- (NSString *)barcode:(NSString *)contents {
    NSMutableString *barcode = [[NSMutableString alloc] initWithString:@""];
    for (int i = 0; i < contents.length; i++) {
        [barcode
         appendString:[self __encodeCharacter:[contents substringWithRange:
                                               NSMakeRange(i, 1)]]];
    }
    return [NSString stringWithString:barcode];
}

@end