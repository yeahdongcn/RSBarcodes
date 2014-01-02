//
//  RSCode128Generator.m
//  RSBarcodesSample
//
//  Created by R0CKSTAR on 12/30/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "RSCode128Generator.h"

static NSString * const CODE128_ALPHABET_STRING = @" !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_'abcdefghijklmnopqrstuvwxyz{|}~";

static NSString * const CODE128_CHARACTER_ENCODINGS[107] = {
    @"11011001100",
    @"11001101100",
    @"11001100110",
    @"10010011000",
    @"10010001100",
    @"10001001100",
    @"10011001000",
    @"10011000100",
    @"10001100100",
    @"11001001000",
    @"11001000100",
    @"11000100100",
    @"10110011100",
    @"10011011100",
    @"10011001110",
    @"10111001100",
    @"10011101100",
    @"10011100110",
    @"11001110010",
    @"11001011100",
    @"11001001110",
    @"11011100100",
    @"11001110100",
    @"11101101110",
    @"11101001100",
    @"11100101100",
    @"11100100110",
    @"11101100100",
    @"11100110100",
    @"11100110010",
    @"11011011000",
    @"11011000110",
    @"11000110110",
    @"10100011000",
    @"10001011000",
    @"10001000110",
    @"10110001000",
    @"10001101000",
    @"10001100010",
    @"11010001000",
    @"11000101000",
    @"11000100010",
    @"10110111000",
    @"10110001110",
    @"10001101110",
    @"10111011000",
    @"10111000110",
    @"10001110110",
    @"11101110110",
    @"11010001110",
    @"11000101110",
    @"11011101000",
    @"11011100010",
    @"11011101110",
    @"11101011000",
    @"11101000110",
    @"11100010110",
    @"11101101000",
    @"11101100010",
    @"11100011010",
    @"11101111010",
    @"11001000010",
    @"11110001010",
    @"10100110000", // 64
    // Visible character encoding for code table A ended.
    @"10100001100",
    @"10010110000",
    @"10010000110",
    @"10000101100",
    @"10000100110",
    @"10110010000",
    @"10110000100",
    @"10011010000",
    @"10011000010",
    @"10000110100",
    @"10000110010",
    @"11000010010",
    @"11001010000",
    @"11110111010",
    @"11000010100",
    @"10001111010",
    @"10100111100",
    @"10010111100",
    @"10010011110",
    @"10111100100",
    @"10011110100",
    @"10011110010",
    @"11110100100",
    @"11110010100",
    @"11110010010",
    @"11011011110",
    @"11011110110",
    @"11110110110",
    @"10101111000",
    @"10100011110",
    @"10001011110",
    // Visible character encoding for code table B ended.
    @"10111101000",
    @"10111100010",
    @"11110101000",
    @"11110100010",
    @"10111011110", // to C from A, B (size - 8)
    @"10111101110", // to B from A, C (size - 7)
    @"11101011110", // to A from B, C (size - 6)
    @"11110101110",
    @"11010000100", // START A (size - 4)
    @"11010010000", // START B (size - 3)
    @"11010011100", // START C (size - 2)
    @"11000111010"  // STOP    (size - 1)
};

@interface RSAutoCodeTable : NSObject

@property (nonatomic) RSCode128GeneratorCodeTable startCodeTable;

@property (nonatomic) NSMutableArray *sequence;

@end

@implementation RSAutoCodeTable

- (NSMutableArray *)sequence
{
    if (!_sequence) {
        _sequence = [[NSMutableArray alloc] init];
    }
    return _sequence;
}

@end

@interface RSCode128Generator ()

@property (nonatomic) NSUInteger codeTableSize;

@property (nonatomic, strong) RSAutoCodeTable *autoCodeTable;

@end

@implementation RSCode128Generator

- (NSString *)__encodeCharacter:(NSString *)character
{
    return CODE128_CHARACTER_ENCODINGS[[CODE128_ALPHABET_STRING rangeOfString:character].location];
}

- (int)__valueForStart:(RSCode128GeneratorCodeTable)start
{
    int valueForStart = 0;
    switch (self.autoCodeTable.startCodeTable) {
        case RSCode128GeneratorCodeTableA:
            valueForStart = self.codeTableSize - 4;
            break;
        case RSCode128GeneratorCodeTableB:
            valueForStart = self.codeTableSize - 3;
            break;
        case RSCode128GeneratorCodeTableC:
            valueForStart = self.codeTableSize - 2;
            break;
        default:
            break;
    }
    return valueForStart;
}

- (int)__switchToCodeTable:(RSCode128GeneratorCodeTable)toCodeTable
{
    int codeTableValue = 0;
    switch (toCodeTable) {
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

- (void)__calculateAutoCodeTable:(NSString *)contents
{
    if (self.codeTable == RSCode128GeneratorCodeTableAuto) {
        // Init auto code table when the other code table is selected
        self.autoCodeTable = [[RSAutoCodeTable alloc] init];
        // Default select short code table A as start code table
        RSCode128GeneratorCodeTable defaultCodeTable = RSCode128GeneratorCodeTableA;
        int index = NSNotFound;
        NSString *CODE128_ALPHABET_STRING_A = [CODE128_ALPHABET_STRING substringToIndex:64];
        for (int i = 0; i < contents.length; i++) {
            NSString *character = [contents substringWithRange:NSMakeRange(i, 1)];
            if ([CODE128_ALPHABET_STRING_A rangeOfString:character].location == NSNotFound) {
                defaultCodeTable = RSCode128GeneratorCodeTableB;
            }
            if ([DIGITS_STRING rangeOfString:character].location == NSNotFound) {
                if (index != NSNotFound) {
                    if ((index == 0 && (i - index) >= 4)
                        || ((index > 0 && (i - index) >= 6))) {
                        // NSMakeRange(index, i - index)
                        // START C when found continous digits from index == 0
                        if (index == 0) {
                            self.autoCodeTable.startCodeTable = RSCode128GeneratorCodeTableC;
                        } else {
                            [self.autoCodeTable.sequence addObject:[NSNumber numberWithInt:[self __switchToCodeTable:RSCode128GeneratorCodeTableC]]];
                        }
                        
                        for (int j = 0; j < (i - index) / 2; j++) {
                            int digitValue = [[contents substringWithRange:NSMakeRange(index + j * 2, 2)] intValue];
                            [self.autoCodeTable.sequence addObject:[NSNumber numberWithInt:digitValue]];
                        }
                        [self.autoCodeTable.sequence addObject:[NSNumber numberWithInt:[self __switchToCodeTable:defaultCodeTable]]];
                        if ((i - index) % 2 == 1) {
                            int digitValue = [CODE128_ALPHABET_STRING rangeOfString:[contents substringWithRange:NSMakeRange(i - 1, 1)]].location;
                            [self.autoCodeTable.sequence addObject:[NSNumber numberWithInt:digitValue]];
                        }
                        int characterValue = [CODE128_ALPHABET_STRING rangeOfString:character].location;
                        [self.autoCodeTable.sequence addObject:[NSNumber numberWithInt:characterValue]];
                        
                        // Reset index
                        index = NSNotFound;
                    } else {
                        
                    }
                } else {
                    int characterValue = [CODE128_ALPHABET_STRING rangeOfString:character].location;
                    [self.autoCodeTable.sequence addObject:[NSNumber numberWithInt:characterValue]];
                }
            } else {
                if (index == NSNotFound) {
                    index = i;
                } else {
                    // todo:
                }
            }
        }
        if (self.autoCodeTable.startCodeTable == RSCode128GeneratorCodeTableAuto) {
            self.autoCodeTable.startCodeTable = defaultCodeTable;
        }
    }
}

- (id)initWithContents:(NSString *)contents
{
    self = [super init];
    if (self) {
        self.codeTable = RSCode128GeneratorCodeTableAuto;
        self.codeTableSize = (NSUInteger)(sizeof(CODE128_CHARACTER_ENCODINGS) / sizeof(NSString *));
    }
    return self;
}

- (BOOL)isContentsValid:(NSString *)contents
{
    if (contents.length > 0) {
        switch (self.codeTable) {
            case RSCode128GeneratorCodeTableAuto:
                [self __calculateAutoCodeTable:contents];
                return YES;
            case RSCode128GeneratorCodeTableA: {
                NSString *CODE128_ALPHABET_STRING_A = [CODE128_ALPHABET_STRING substringToIndex:64];
                for (int i = 0; i < contents.length; i++) {
                    if ([CODE128_ALPHABET_STRING_A rangeOfString:[contents substringWithRange:NSMakeRange(i, 1)]].location == NSNotFound) {
                        return NO;
                    }
                }
                return YES;
            }
            case RSCode128GeneratorCodeTableB:
                for (int i = 0; i < contents.length; i++) {
                    if ([CODE128_ALPHABET_STRING rangeOfString:[contents substringWithRange:NSMakeRange(i, 1)]].location == NSNotFound) {
                        return NO;
                    }
                }
                return YES;
            case RSCode128GeneratorCodeTableC:
                // http://stackoverflow.com/questions/6644004/how-to-check-if-nsstring-is-contains-a-numeric-value
                if (contents.length % 2 == 0
                    && [contents rangeOfCharacterFromSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]].location == NSNotFound) {
                    return YES;
                }
                return NO;
            default:
                return NO;
        }
    }
    return NO;
}

- (NSString *)initiator
{
    NSString *initiator = [super initiator];
    switch (self.codeTable) {
        case RSCode128GeneratorCodeTableAuto:
            initiator = CODE128_CHARACTER_ENCODINGS[[self __valueForStart:self.autoCodeTable.startCodeTable]];
            break;
        case RSCode128GeneratorCodeTableA:
        case RSCode128GeneratorCodeTableB:
        case RSCode128GeneratorCodeTableC:
        default:
            initiator = CODE128_CHARACTER_ENCODINGS[[self __valueForStart:self.codeTable]];
            break;
    }
    return initiator;
}

- (NSString *)terminator
{
    return [NSString stringWithFormat:@"%@%@", CODE128_CHARACTER_ENCODINGS[self.codeTableSize - 1], @"11"];
}

- (NSString *)barcode:(NSString *)contents
{
    NSMutableString *barcode = [[NSMutableString alloc] initWithString:@""];

    switch (self.codeTable) {
        case RSCode128GeneratorCodeTableAuto:
            for (int i = 0; i < self.autoCodeTable.sequence.count; i++) {
                [barcode appendString:CODE128_CHARACTER_ENCODINGS[[self.autoCodeTable.sequence[i] intValue]]];
            }
            break;
        case RSCode128GeneratorCodeTableA:
        case RSCode128GeneratorCodeTableB:
            for (int i = 0; i < contents.length; i++) {
                [barcode appendString:[self __encodeCharacter:[contents substringWithRange:NSMakeRange(i, 1)]]];
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

- (NSString *)checkDigit:(NSString *)contents
{
    int sum = 0;
    switch (self.codeTable) {
        case RSCode128GeneratorCodeTableAuto:
            sum += [self __valueForStart:self.autoCodeTable.startCodeTable];
            for (int i = 0; i < self.autoCodeTable.sequence.count; i++) {
                sum += [self.autoCodeTable.sequence[i] intValue] * (i + 1);
            }
            break;
        case RSCode128GeneratorCodeTableA:
            sum = -1; // START A = self.codeTableSize - 4 = START B - 1
        case RSCode128GeneratorCodeTableB:
            sum += self.codeTableSize - 3; // START B
            for (int i = 0; i < contents.length; i++) {
                int characterValue = [CODE128_ALPHABET_STRING rangeOfString:[contents substringWithRange:NSMakeRange(i, 1)]].location;
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