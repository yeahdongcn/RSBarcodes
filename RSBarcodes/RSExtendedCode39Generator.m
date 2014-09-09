//
//  RSExtendedCode39Generator.m
//  RSBarcodes
//
//  Created by R0CKSTAR on 12/26/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "RSExtendedCode39Generator.h"

NSString *const RSMetadataObjectTypeExtendedCode39Code =
@"com.pdq.rsbarcodes.code39.ext";

@implementation RSExtendedCode39Generator

- (NSString *)__encodeContents:(NSString *)contents {
    NSMutableString *newContents = [[NSMutableString alloc] initWithString:@""];
    for (int i = 0; i < contents.length; i++) {
        NSString *character = [contents substringWithRange:NSMakeRange(i, 1)];
        char ch = [character UTF8String][0];
        switch (ch) {
            case 'a':
            case 'b':
            case 'c':
            case 'd':
            case 'e':
            case 'f':
            case 'g':
            case 'h':
            case 'i':
            case 'j':
            case 'k':
            case 'l':
            case 'm':
            case 'n':
            case 'o':
            case 'p':
            case 'q':
            case 'r':
            case 's':
            case 't':
            case 'u':
            case 'v':
            case 'w':
            case 'x':
            case 'y':
            case 'z':
                [newContents appendFormat:@"%@%@", @"+", [character uppercaseString]];
                break;
                
            case '!':
                [newContents appendFormat:@"%@%@", @"/", @"A"];
                break;
            case '"':
                [newContents appendFormat:@"%@%@", @"/", @"B"];
                break;
            case '#':
                [newContents appendFormat:@"%@%@", @"/", @"C"];
                break;
            case '$':
                [newContents appendFormat:@"%@%@", @"/", @"D"];
                break;
            case '%':
                [newContents appendFormat:@"%@%@", @"/", @"E"];
                break;
            case '&':
                [newContents appendFormat:@"%@%@", @"/", @"F"];
                break;
            case '\'':
                [newContents appendFormat:@"%@%@", @"/", @"G"];
                break;
            case '(':
                [newContents appendFormat:@"%@%@", @"/", @"H"];
                break;
            case ')':
                [newContents appendFormat:@"%@%@", @"/", @"I"];
                break;
            case '*':
                [newContents appendFormat:@"%@%@", @"/", @"J"];
                break;
            case '+':
                [newContents appendFormat:@"%@%@", @"/", @"K"];
                break;
            case ',':
                [newContents appendFormat:@"%@%@", @"/", @"L"];
                break;
                // -   ->   /M   better to use -
                // .   ->   /N   better to use .
            case '/':
                [newContents appendFormat:@"%@%@", @"/", @"O"];
                break;
                // 0   ->   /P   better to use 0
                // 1   ->   /Q   better to use 1
                // 2   ->   /R   better to use 2
                // 3   ->   /S   better to use 3
                // 4   ->   /T   better to use 4
                // 5   ->   /U   better to use 5
                // 6   ->   /V   better to use 6
                // 7   ->   /W   better to use 7
                // 8   ->   /X   better to use 8
                // 9   ->   /Y   better to use 9
            case ':':
                [newContents appendFormat:@"%@%@", @"/", @"Z"];
                break;
                
                // ESC ->   %A
                // FS  ->   %B
                // GS  ->   %C
                // RS  ->   %D
                // US  ->   %E
            case ';':
                [newContents appendFormat:@"%@%@", @"%", @"F"];
                break;
            case '<':
                [newContents appendFormat:@"%@%@", @"%", @"G"];
                break;
            case '=':
                [newContents appendFormat:@"%@%@", @"%", @"H"];
                break;
            case '>':
                [newContents appendFormat:@"%@%@", @"%", @"I"];
                break;
            case '?':
                [newContents appendFormat:@"%@%@", @"%", @"J"];
                break;
            case '[':
                [newContents appendFormat:@"%@%@", @"%", @"K"];
                break;
            case '\\':
                [newContents appendFormat:@"%@%@", @"%", @"L"];
                break;
            case ']':
                [newContents appendFormat:@"%@%@", @"%", @"M"];
                break;
            case '^':
                [newContents appendFormat:@"%@%@", @"%", @"N"];
                break;
            case '_':
                [newContents appendFormat:@"%@%@", @"%", @"O"];
                break;
            case '{':
                [newContents appendFormat:@"%@%@", @"%", @"P"];
                break;
            case '|':
                [newContents appendFormat:@"%@%@", @"%", @"Q"];
                break;
            case '}':
                [newContents appendFormat:@"%@%@", @"%", @"R"];
                break;
            case '~':
                [newContents appendFormat:@"%@%@", @"%", @"S"];
                break;
                // DEL   ->   %T
                // NUL   ->   %U
            case '@':
                [newContents appendFormat:@"%@%@", @"%", @"V"];
                break;
            case '`':
                [newContents appendFormat:@"%@%@", @"%", @"W"];
                break;
                
                // SOH   ->   $A
                // STX   ->   $B
                // ETX   ->   $C
                // EOT   ->   $D
                // ENQ   ->   $E
                // ACK   ->   $F
                // BEL   ->   $G
                // BS    ->   $H
            case '\t':
                [newContents appendFormat:@"%@%@", @"$", @"I"];
                break;
                // LF    ->   $J
                // VT    ->   $K
                // FF    ->   $L
            case '\n':
                [newContents appendFormat:@"%@%@", @"$", @"M"];
                break;
                // SO    ->   $N
                // SI    ->   $O
                // DLE   ->   $P
                // DC1   ->   $Q
                // DC2   ->   $R
                // DC3   ->   $S
                // DC4   ->   $T
                // NAK   ->   $U
                // SYN   ->   $V
                // ETB   ->   $W
                // CAN   ->   $X
                // EM    ->   $Y
                // SUB   ->   $Z
                
            default:
                [newContents appendString:character];
                break;
        }
    }
    
    return [NSString stringWithString:newContents];
}

- (BOOL)isContentsValid:(NSString *)contents {
    return contents.length > 0 ? YES : NO;
}

- (NSString *)barcode:(NSString *)contents {
    return [super barcode:[self __encodeContents:contents]];
}

@end
