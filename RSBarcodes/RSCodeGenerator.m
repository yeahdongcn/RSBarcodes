//
//  RSCodeGenerator.m
//  RSBarcodes
//
//  Created by R0CKSTAR on 12/25/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "RSCodeGenerator.h"

@implementation RSAbstractCodeGenerator

@synthesize strokeColor = _strokeColor, fillColor = _fillColor;

NSString *const DIGITS_STRING = @"0123456789";

CGFloat const WIDTH_REF = 90.f; 
CGFloat const HEIGHT_REF = 28.f; 
 
CGFloat const TOP_SPACING_REF = 1.5f; 
CGFloat const BOTTOM_SPACING_REF = 2.f; 
CGFloat const SIDE_SPACING_REF = 2.f; 
CGFloat fixRatio = 0.8;

- (BOOL)isContentsValid:(NSString *)contents {
    if (contents.length > 0) {
        for (int i = 0; i < contents.length; i++) {
            if ([DIGITS_STRING
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
    return @"";
}

- (NSString *)terminator {
    return @"";
}

- (NSString *)barcode:(NSString *)contents {
    return @"";
}

- (NSString *)completeBarcode:(NSString *)barcode {
    return [NSString
            stringWithFormat:@"%@%@%@", [self initiator], barcode, [self terminator]];
}

- (UIImage *)drawCompleteBarcode:(NSString *)code withWidth:(CGFloat)width withHeight:(CGFloat)height {
    if (code.length <= 0) {
        return nil;
    }
    
    // Values taken from CIImage generated AVMetadataObjectTypePDF417Code type
    // image
    // Top spacing          = 1.5
    // Bottom spacing       = 2
    // Left & right spacing = 2
    // Height               = 28        = 112 
    // Width = 90 ==> lineWith 1 
     
    CGFloat widthRatio = width / WIDTH_REF; 
    CGFloat heightRatio = height / HEIGHT_REF; 
 
    CGSize size = CGSizeMake(width, height); 
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetShouldAntialias(context, false);
    
    if (!self.fillColor) {
        self.fillColor = [UIColor whiteColor];
    }
    
    if (!self.strokeColor) {
        self.strokeColor = [UIColor blackColor];
    }
    
    [self.fillColor setFill];
    [self.strokeColor setStroke];
    
    CGContextFillRect(context, CGRectMake(0, 0, size.width, size.height));
    CGContextSetLineWidth(context, widthRatio * fixRatio);
    
    for (int i = 0; i < code.length; i++) {
        NSString *character = [code substringWithRange:NSMakeRange(i, 1)];
        if ([character isEqualToString:@"1"]) {
            CGContextMoveToPoint(context, ((i + (SIDE_SPACING_REF * heightRatio + widthRatio)) * widthRatio) * fixRatio, TOP_SPACING_REF * heightRatio);
            CGContextAddLineToPoint(context, ((i + (SIDE_SPACING_REF * heightRatio + widthRatio)) * widthRatio) * fixRatio , size.height - BOTTOM_SPACING_REF * heightRatio);        }
    }
    CGContextDrawPath(context, kCGPathFillStroke);
    
    UIImage *barcode = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return barcode;
}

#pragma mark - RSCodeGenerator

- (UIImage *)genCodeWithContents:(NSString *)contents
   machineReadableCodeObjectType:(NSString *)type withWidth:(CGFloat)width withHeight:(CGFloat)height {
    return [self drawCompleteBarcode:[self completeBarcode:[self barcode:contents]] withWidth:width withHeight:height];
}

- (UIImage *)genCodeWithMachineReadableCodeObject:
(AVMetadataMachineReadableCodeObject *)
machineReadableCodeObject withWidth:(CGFloat)width withHeight:(CGFloat)height { 
    return [self genCodeWithContents:[machineReadableCodeObject stringValue]
       machineReadableCodeObjectType:[machineReadableCodeObject type] withWidth:width withHeight:height];
}

@end
