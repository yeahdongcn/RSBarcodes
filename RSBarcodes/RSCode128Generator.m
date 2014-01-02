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
    @"10111011110",
    @"10111101110",
    @"11101011110",
    @"11110101110",
    @"11010000100", // START A (size - 4)
    @"11010010000", // START B (size - 3)
    @"11010011100", // START C (size - 2)
    @"11000111010"  // STOP    (size - 1)
};

@interface RSCode128Generator ()

@property (nonatomic) NSUInteger codeTableSize;

@end

@implementation RSCode128Generator

- (NSString *)__encodeCharacter:(NSString *)character
{
    return CODE128_CHARACTER_ENCODINGS[[CODE128_ALPHABET_STRING rangeOfString:character].location];
}

- (id)initWithContents:(NSString *)contents
{
    self = [super init];
    if (self) {
        self.codeTable = RSCode128GeneratorCodeTableB;
        self.codeTableSize = (NSUInteger)(sizeof(CODE128_CHARACTER_ENCODINGS) / sizeof(NSString *));
    }
    return self;
}

- (BOOL)isContentsValid:(NSString *)contents
{
    if (contents.length > 0) {
        switch (self.codeTable) {
            case RSCode128GeneratorCodeTableAuto:
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
                break;
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
            NSLog(@"Note!");
            break;
        case RSCode128GeneratorCodeTableA:
            initiator = CODE128_CHARACTER_ENCODINGS[self.codeTableSize - 4];
            break;
        case RSCode128GeneratorCodeTableB:
            initiator = CODE128_CHARACTER_ENCODINGS[self.codeTableSize - 3];
            break;
        case RSCode128GeneratorCodeTableC:
            initiator = CODE128_CHARACTER_ENCODINGS[self.codeTableSize - 2];
            break;
        default:
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
    for (int i = 0; i < contents.length; i++) {
        [barcode appendString:[self __encodeCharacter:[contents substringWithRange:NSMakeRange(i, 1)]]];
    }
    if ([self respondsToSelector:@selector(checkDigit:)]) {
        return [NSString stringWithFormat:@"%@%@", barcode, [self checkDigit:contents]];
    } else {
        return [NSString stringWithString:barcode];
    }
}

#pragma mark - RSCheckDigitGenerator

- (NSString *)checkDigit:(NSString *)contents
{
    int sum = 0;
    switch (self.codeTable) {
        case RSCode128GeneratorCodeTableAuto:
            NSLog(@"Note!");
            break;
        case RSCode128GeneratorCodeTableA:
            sum = -1; // START A = self.codeTableSize - 4 = START B - 1
        case RSCode128GeneratorCodeTableB:
            sum += self.codeTableSize - 3; // START B
            for (int i = 0; i < contents.length; i++) {
                NSString *character = [contents substringWithRange:NSMakeRange(i, 1)];
                int characterValue = [CODE128_ALPHABET_STRING rangeOfString:character].location;
                sum += characterValue * (i + 1);
            }
            break;
        case RSCode128GeneratorCodeTableC:
            sum += self.codeTableSize - 2; // START C
            break;
        default:
            break;
    }
    return CODE128_CHARACTER_ENCODINGS[sum % 103];
}

@end