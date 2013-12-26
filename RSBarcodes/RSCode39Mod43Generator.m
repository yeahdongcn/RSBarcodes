//
//  RSCode39Mod43Generator.m
//  RSBarcodesSample
//
//  Created by R0CKSTAR on 12/26/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "RSCode39Mod43Generator.h"

@implementation RSCode39Mod43Generator

- (NSString *)__checksum:(NSString *)contents
{
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
    return [CODE39_ALPHABET_STRING substringWithRange:NSMakeRange(sum % 43, 1)];
}

- (NSString *)barcode:(NSString *)contents
{
    return [super barcode:[NSString stringWithFormat:@"%@%@", contents, [self __checksum:[contents uppercaseString]]]];
}

@end
