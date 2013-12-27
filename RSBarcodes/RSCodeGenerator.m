//
//  RSCodeGenerator.m
//  RSBarcodes
//
//  Created by R0CKSTAR on 12/25/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "RSCodeGenerator.h"

@implementation RSAbstractCodeGenerator

NSString * const DIGITS_STRING = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-. $/+%*";

- (BOOL)isContentsValid:(NSString *)contents
{
    if (contents.length > 0) {
        for (int i = 0; i < contents.length; i++) {
            if ([DIGITS_STRING rangeOfString:[contents substringWithRange:NSMakeRange(i, 1)]].location == NSNotFound) {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

- (NSString *)initiator
{
    return @"";
}

- (NSString *)terminator
{
    return @"";
}

- (NSString *)barcode:(NSString *)contents
{
    return @"";
}

- (NSString *)completeBarcode:(NSString *)barcode
{
    return [NSString stringWithFormat:@"%@%@%@", [self initiator], barcode, [self terminator]];
}

- (UIImage *)drawCompleteBarcode:(NSString *)code
{
    CGSize size = CGSizeMake(code.length + 10, roundf(code.length / 4.0));
    UIGraphicsBeginImageContextWithOptions(size, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor whiteColor] setFill];
    [[UIColor blackColor] setStroke];
    
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    CGContextSetLineWidth(context, 1.0);
    
    for (int i = 0; i < code.length; i++) {
        NSString *character = [code substringWithRange:NSMakeRange(i, 1)];
        if ([character isEqualToString:@"1"]) {
            CGContextMoveToPoint(context, i + 5, 5);
            CGContextAddLineToPoint(context, i + 5, size.height - 5);
        }
    }
    CGContextDrawPath(context, kCGPathFillStroke);
    
    UIImage *barcode = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return barcode;
}

- (UIImage *)encode:(NSString *)contents codeObjectType:(NSString *)codeObjectType
{
    if ([self isContentsValid:contents]) {
        return [self drawCompleteBarcode:[self completeBarcode:[self barcode:contents]]];
    }
    return nil;
}

@end