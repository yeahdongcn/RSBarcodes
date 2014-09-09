//
//  RSCode39Mod43Generator.m
//  RSBarcodes
//
//  Created by R0CKSTAR on 12/26/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "RSCode39Mod43Generator.h"

@implementation RSCode39Mod43Generator

- (NSString *)barcode:(NSString *)contents {
    if ([self respondsToSelector:@selector(checkDigit:)]) {
        return [super
                barcode:[NSString stringWithFormat:
                         @"%@%@", contents,
                         [self checkDigit:[contents uppercaseString]]]];
    } else {
        return [super barcode:contents];
    }
}

#pragma mark - RSCheckDigitGenerator

- (NSString *)checkDigit:(NSString *)contents {
    /*
     Step 1: From the table below, find the values of each character.
     C    O    D    E        3    9    <--Message characters
     12   24   13   14  38   3    9    <--Character values
     Step 2: Sum the character values.
     12 + 24 + 13 + 14 + 38 + 3 + 9 = 113
     Step 3: Divide the result by 43.
     113 / 43 = 11  with remainder of 27.
     Step 4: From the table, find the character with this value
     27 = R = Check Character
     */
    int sum = 0;
    for (int i = 0; i < contents.length; i++) {
        NSString *character = [contents substringWithRange:NSMakeRange(i, 1)];
        sum += [CODE39_ALPHABET_STRING rangeOfString:character].location;
    }
    // 43 = CODE39_ALPHABET_STRING's length - 1 -- excludes asterisk
    return [CODE39_ALPHABET_STRING
            substringWithRange:NSMakeRange(sum % (CODE39_ALPHABET_STRING.length - 1),
                                           1)];
}

@end
