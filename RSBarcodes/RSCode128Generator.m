//
//  RSCode128Generator.m
//  RSBarcodes
//
//  Created by R0CKSTAR on 12/30/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "RSCode128Generator.h"

static NSString *const CODE128_ALPHABET_STRING =
@" !\"#$%&'()*+,-./"
@"0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_'"
@"abcdefghijklmnopqrstuvwxyz{|}~";

static NSString *const CODE128_CHARACTER_ENCODINGS[107] = {
    @"11011001100", @"11001101100", @"11001100110", @"10010011000",
    @"10010001100", @"10001001100", @"10011001000", @"10011000100",
    @"10001100100", @"11001001000", @"11001000100", @"11000100100",
    @"10110011100", @"10011011100", @"10011001110", @"10111001100",
    @"10011101100", @"10011100110", @"11001110010", @"11001011100",
    @"11001001110", @"11011100100", @"11001110100", @"11101101110",
    @"11101001100", @"11100101100", @"11100100110", @"11101100100",
    @"11100110100", @"11100110010", @"11011011000", @"11011000110",
    @"11000110110", @"10100011000", @"10001011000", @"10001000110",
    @"10110001000", @"10001101000", @"10001100010", @"11010001000",
    @"11000101000", @"11000100010", @"10110111000", @"10110001110",
    @"10001101110", @"10111011000", @"10111000110", @"10001110110",
    @"11101110110", @"11010001110", @"11000101110", @"11011101000",
    @"11011100010", @"11011101110", @"11101011000", @"11101000110",
    @"11100010110", @"11101101000", @"11101100010", @"11100011010",
    @"11101111010", @"11001000010", @"11110001010", @"10100110000", // 64
    // Visible character encoding for code table A ended.
    @"10100001100", @"10010110000", @"10010000110", @"10000101100",
    @"10000100110", @"10110010000", @"10110000100", @"10011010000",
    @"10011000010", @"10000110100", @"10000110010", @"11000010010",
    @"11001010000", @"11110111010", @"11000010100", @"10001111010",
    @"10100111100", @"10010111100", @"10010011110", @"10111100100",
    @"10011110100", @"10011110010", @"11110100100", @"11110010100",
    @"11110010010", @"11011011110", @"11011110110", @"11110110110",
    @"10101111000", @"10100011110", @"10001011110",
    // Visible character encoding for code table B ended.
    @"10111101000", @"10111100010", @"11110101000", @"11110100010",
    @"10111011110",                 // to C from A, B (size - 8)
    @"10111101110",                 // to B from A, C (size - 7)
    @"11101011110",                 // to A from B, C (size - 6)
    @"11110101110", @"11010000100", // START A (size - 4)
    @"11010010000",                 // START B (size - 3)
    @"11010011100",                 // START C (size - 2)
    @"11000111010"                  // STOP    (size - 1)
};

@interface RSAutoCodeTable : NSObject

@property(nonatomic) RSCode128GeneratorCodeTable startCodeTable;

@property(nonatomic) NSMutableArray *sequence;

@end

@implementation RSAutoCodeTable

- (NSMutableArray *)sequence {
    if (!_sequence) {
        _sequence = [[NSMutableArray alloc] init];
    }
    return _sequence;
}

@end

@interface RSCode128Generator ()

@property(nonatomic) NSUInteger codeTableSize;

@property(nonatomic, strong) RSAutoCodeTable *autoCodeTable;

@end

@implementation RSCode128Generator

- (NSString *)__encodeCharacter:(NSString *)character {
    return CODE128_CHARACTER_ENCODINGS[
                                       [CODE128_ALPHABET_STRING rangeOfString:character].location];
}

- (NSUInteger)__startCodeTableValue:
(RSCode128GeneratorCodeTable)startCodeTable {
    NSUInteger codeTableValue = 0;
    switch (self.autoCodeTable.startCodeTable) {
        case RSCode128GeneratorCodeTableA:
            codeTableValue = self.codeTableSize - 4;
            break;
        case RSCode128GeneratorCodeTableB:
            codeTableValue = self.codeTableSize - 3;
            break;
        case RSCode128GeneratorCodeTableC:
            codeTableValue = self.codeTableSize - 2;
            break;
        default:
            break;
    }
    return codeTableValue;
}

- (NSUInteger)__middleCodeTableValue:(RSCode128GeneratorCodeTable)codeTable {
    NSUInteger codeTableValue = 0;
    switch (codeTable) {
        case RSCode128GeneratorCodeTableA:
            codeTableValue = self.codeTableSize - 6;
            break;
        case RSCode128GeneratorCodeTableB:
            codeTableValue = self.codeTableSize - 7;
            break;
        case RSCode128GeneratorCodeTableC:
            codeTableValue = self.codeTableSize - 8;
            break;
        default:
            break;
    }
    return codeTableValue;
}

- (void)__calculateContinousDigitsWithContents:(NSString *)contents
                              defaultCodeTable:
(RSCode128GeneratorCodeTable)defaultCodeTable
                          continousDigitsRange:(NSRange)range {
    NSUInteger currentIndex = range.location + range.length;
    BOOL isFinished = NO;
    if (currentIndex == contents.length) {
        isFinished = YES;
    }

    if ((range.location == 0 && range.length >= 4) ||
        ((range.location > 0 && range.length >= 6))) {
        BOOL isOrphanDigitUsed = NO;

        // Use START C when continous digits are found from range.location == 0
        if (range.location == 0) {
            self.autoCodeTable.startCodeTable = RSCode128GeneratorCodeTableC;
        } else {
            if (range.length % 2 == 1) {
                NSUInteger digitValue =
                [CODE128_ALPHABET_STRING
                 rangeOfString:[contents
                                substringWithRange:NSMakeRange(range.location,
                                                               1)]].location;
                [self.autoCodeTable.sequence
                 addObject:[NSNumber numberWithInteger:digitValue]];
                isOrphanDigitUsed = YES;
            }
            [self.autoCodeTable.sequence
             addObject:[NSNumber numberWithInteger:
                        [self __middleCodeTableValue:
                         RSCode128GeneratorCodeTableC]]];
        }

        // Insert all xx combinations
        for (int i = 0; i < range.length / 2; i++) {
            NSUInteger startIndex = range.location + i * 2;
            int digitValue = [[contents
                               substringWithRange:NSMakeRange(isOrphanDigitUsed ? startIndex + 1
                                                              : startIndex,
                                                              2)] intValue];
            [self.autoCodeTable.sequence
             addObject:[NSNumber numberWithInt:digitValue]];
        }

        if ((range.length % 2 == 1 && !isOrphanDigitUsed) || !isFinished) {
            [self.autoCodeTable.sequence
             addObject:[NSNumber numberWithInteger:[self __middleCodeTableValue:
                                                    defaultCodeTable]]];
        }

        if (range.length % 2 == 1 && !isOrphanDigitUsed) {
            NSUInteger digitValue =
            [CODE128_ALPHABET_STRING
             rangeOfString:[contents
                            substringWithRange:NSMakeRange(currentIndex - 1,
                                                           1)]].location;
            [self.autoCodeTable.sequence
             addObject:[NSNumber numberWithInteger:digitValue]];
        }

        if (!isFinished) {
            NSString *character =
            [contents substringWithRange:NSMakeRange(currentIndex, 1)];
            NSUInteger characterValue =
            [CODE128_ALPHABET_STRING rangeOfString:character].location;
            [self.autoCodeTable.sequence
             addObject:[NSNumber numberWithInteger:characterValue]];
        }
    } else {
        for (NSUInteger j = range.location;
             j <= (isFinished ? currentIndex - 1 : currentIndex); j++) {
            NSUInteger characterValue =
            [CODE128_ALPHABET_STRING
             rangeOfString:[contents substringWithRange:NSMakeRange(j, 1)]]
            .location;
            [self.autoCodeTable.sequence
             addObject:[NSNumber numberWithInteger:characterValue]];
        }
    }
}

- (void)__calculateAutoCodeTableWithContents:(NSString *)contents {
    if (self.codeTable == RSCode128GeneratorCodeTableAuto) {
        // Init auto code table when the other code table has not been selected
        self.autoCodeTable = [[RSAutoCodeTable alloc] init];

        // Select the short code table A as default code table
        RSCode128GeneratorCodeTable defaultCodeTable = RSCode128GeneratorCodeTableA;

        // Determine whether to use code table B
        NSString *CODE128_ALPHABET_STRING_A =
        [CODE128_ALPHABET_STRING substringToIndex:64];
        for (int i = 0; i < contents.length; i++) {
            if ([CODE128_ALPHABET_STRING_A
                 rangeOfString:[contents substringWithRange:NSMakeRange(i, 1)]]
                .location == NSNotFound &&
                defaultCodeTable == RSCode128GeneratorCodeTableA) {
                defaultCodeTable = RSCode128GeneratorCodeTableB;
                break;
            }
        }

        NSUInteger continousDigitsStartIndex = NSNotFound;
        for (int i = 0; i < contents.length; i++) {
            NSString *character = [contents substringWithRange:NSMakeRange(i, 1)];
            NSRange continousDigitsRange = NSMakeRange(0, 0);
            if ([DIGITS_STRING rangeOfString:character].location == NSNotFound) {
                // Non digit found
                if (continousDigitsStartIndex != NSNotFound) {
                    continousDigitsRange = NSMakeRange(continousDigitsStartIndex,
                                                       i - continousDigitsStartIndex);
                } else {
                    NSUInteger characterValue =
                    [CODE128_ALPHABET_STRING rangeOfString:character].location;
                    [self.autoCodeTable.sequence
                     addObject:[NSNumber numberWithInteger:characterValue]];
                }
            } else {
                // Digit found
                if (continousDigitsStartIndex == NSNotFound) {
                    continousDigitsStartIndex = i;
                }
                if (continousDigitsStartIndex != NSNotFound && i == (contents.length - 1)) {
                    continousDigitsRange = NSMakeRange(continousDigitsStartIndex,
                                                       i - continousDigitsStartIndex + 1);
                }
            }

            if (continousDigitsRange.length != 0) {
                [self __calculateContinousDigitsWithContents:contents
                                            defaultCodeTable:defaultCodeTable
                                        continousDigitsRange:continousDigitsRange];
                continousDigitsStartIndex = NSNotFound;
            } else if (continousDigitsStartIndex == contents.length - 1 && continousDigitsRange.length == 0) {
                NSUInteger characterValue =
                [CODE128_ALPHABET_STRING rangeOfString:character].location;
                [self.autoCodeTable.sequence
                 addObject:[NSNumber numberWithInteger:characterValue]];
            }
        }
        
        if (self.autoCodeTable.startCodeTable == RSCode128GeneratorCodeTableAuto) {
            self.autoCodeTable.startCodeTable = defaultCodeTable;
        }
    }
}

- (id)initWithContents:(NSString *)contents {
    self = [super init];
    if (self) {
        self.codeTable = RSCode128GeneratorCodeTableAuto;
        self.codeTableSize =
        (NSUInteger)(sizeof(CODE128_CHARACTER_ENCODINGS) / sizeof(NSString *));
    }
    return self;
}

- (BOOL)isContentsValid:(NSString *)contents {
    if (contents.length > 0) {
        for (int i = 0; i < contents.length; i++) {
            if ([CODE128_ALPHABET_STRING
                 rangeOfString:[contents substringWithRange:NSMakeRange(i, 1)]]
                .location == NSNotFound) {
                return NO;
            }
        }
        switch (self.codeTable) {
            case RSCode128GeneratorCodeTableAuto:
                [self __calculateAutoCodeTableWithContents:contents];
                return YES;
            case RSCode128GeneratorCodeTableA: {
                NSString *CODE128_ALPHABET_STRING_A =
                [CODE128_ALPHABET_STRING substringToIndex:64];
                for (int i = 0; i < contents.length; i++) {
                    if ([CODE128_ALPHABET_STRING_A
                         rangeOfString:[contents substringWithRange:NSMakeRange(i, 1)]]
                        .location == NSNotFound) {
                        return NO;
                    }
                }
                return YES;
            }
            case RSCode128GeneratorCodeTableB:
                for (int i = 0; i < contents.length; i++) {
                    if ([CODE128_ALPHABET_STRING
                         rangeOfString:[contents substringWithRange:NSMakeRange(i, 1)]]
                        .location == NSNotFound) {
                        return NO;
                    }
                }
                return YES;
            case RSCode128GeneratorCodeTableC:
                // http://stackoverflow.com/questions/6644004/how-to-check-if-nsstring-is-contains-a-numeric-value
                if (contents.length % 2 == 0 &&
                    [contents rangeOfCharacterFromSet:
                     [[NSCharacterSet decimalDigitCharacterSet] invertedSet]]
                    .location == NSNotFound) {
                    return YES;
                }
                return NO;
            default:
                return NO;
        }
    }
    return NO;
}

- (NSString *)initiator {
    NSString *initiator = nil;
    switch (self.codeTable) {
        case RSCode128GeneratorCodeTableAuto:
            initiator = CODE128_CHARACTER_ENCODINGS[
                                                    [self __startCodeTableValue:self.autoCodeTable.startCodeTable]];
            break;
        case RSCode128GeneratorCodeTableA:
        case RSCode128GeneratorCodeTableB:
        case RSCode128GeneratorCodeTableC:
        default:
            initiator = CODE128_CHARACTER_ENCODINGS[
                                                    [self __startCodeTableValue:self.codeTable]];
            break;
    }
    return initiator;
}

- (NSString *)terminator {
    return [NSString
            stringWithFormat:@"%@%@",
            CODE128_CHARACTER_ENCODINGS[self.codeTableSize - 1],
            @"11"];
}

- (NSString *)barcode:(NSString *)contents {
    NSMutableString *barcode = [[NSMutableString alloc] initWithString:@""];

    switch (self.codeTable) {
        case RSCode128GeneratorCodeTableAuto:
            for (int i = 0; i < self.autoCodeTable.sequence.count; i++) {
                [barcode appendString:CODE128_CHARACTER_ENCODINGS[
                                                                  [self.autoCodeTable.sequence[i] intValue]]];
            }
            break;
        case RSCode128GeneratorCodeTableA:
        case RSCode128GeneratorCodeTableB:
            for (int i = 0; i < contents.length; i++) {
                [barcode appendString:[self __encodeCharacter:
                                       [contents substringWithRange:NSMakeRange(
                                                                                i, 1)]]];
            }
            break;
        case RSCode128GeneratorCodeTableC:
            for (int i = 0; i < contents.length; i++) {
                if (i % 2 == 1) {
                    continue;
                } else {
                    int value = [[contents substringWithRange:NSMakeRange(i, 2)] intValue];
                    [barcode appendString:CODE128_CHARACTER_ENCODINGS[value]];
                }
            }
            break;
    }
    if ([self respondsToSelector:@selector(checkDigit:)]) {
        [barcode appendString:[self checkDigit:contents]];
    }
    return [NSString stringWithString:barcode];
}

#pragma mark - RSCheckDigitGenerator

- (NSString *)checkDigit:(NSString *)contents {
    int sum = 0;
    switch (self.codeTable) {
        case RSCode128GeneratorCodeTableAuto:
            sum += [self __startCodeTableValue:self.autoCodeTable.startCodeTable];
            for (int i = 0; i < self.autoCodeTable.sequence.count; i++) {
                sum += [self.autoCodeTable.sequence[i] intValue] * (i + 1);
            }
            break;
        case RSCode128GeneratorCodeTableA:
            sum = -1; // START A = self.codeTableSize - 4 = START B - 1
        case RSCode128GeneratorCodeTableB:
            sum += self.codeTableSize - 3; // START B
            for (int i = 0; i < contents.length; i++) {
                NSUInteger characterValue =
                [CODE128_ALPHABET_STRING
                 rangeOfString:[contents substringWithRange:NSMakeRange(i, 1)]]
                .location;
                sum += characterValue * (i + 1);
            }
            break;
        case RSCode128GeneratorCodeTableC:
            sum += self.codeTableSize - 2; // START C
            for (int i = 0; i < contents.length; i++) {
                if (i % 2 == 1) {
                    continue;
                } else {
                    int value = [[contents substringWithRange:NSMakeRange(i, 2)] intValue];
                    sum += value * (i / 2 + 1);
                }
            }
            break;
        default:
            break;
    }
    return CODE128_CHARACTER_ENCODINGS[sum % 103];
}

@end
