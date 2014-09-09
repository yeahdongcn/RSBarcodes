//
//  RSCodeGenerator.h
//  RSBarcodes
//
//  Created by R0CKSTAR on 12/25/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

/**
 *  Code generators are required to provide these two functions.
 */
@protocol RSCodeGenerator <NSObject>

@required

- (UIImage *)genCodeWithMachineReadableCodeObject:
(AVMetadataMachineReadableCodeObject *)machineReadableCodeObject;

- (UIImage *)genCodeWithContents:(NSString *)contents
   machineReadableCodeObjectType:(NSString *)type;

@end

/**
 *  Check digit are not required for all code generators.
 *  UPC-E is using check digit to valid the contents to be encoded.
 *  Code39Mod43, Code93 and Code128 is using check digit to encode barcode.
 */
@protocol RSCheckDigitGenerator <NSObject>

@optional

- (NSString *)checkDigit:(NSString *)contents;

@end

extern NSString *const DIGITS_STRING;

/**
 *  Abstract code generator, provides default functions for validations and
 * generations.
 */
@interface RSAbstractCodeGenerator : NSObject <RSCodeGenerator>

/**
 *  Check whether the given contents are valid.
 *
 *  @param contents Contents to be encoded.
 *
 *  @return
 */
- (BOOL)isContentsValid:(NSString *)contents;

/**
 *  Barcode initiator, subclass should return its own value.
 *
 *  @return
 */
- (NSString *)initiator;

/**
 *  Barcode terminator, subclass should return its own value.
 *
 *  @return
 */
- (NSString *)terminator;

/**
 *  Barcode content, subclass should return its own value.
 *
 *  @return
 */
- (NSString *)barcode:(NSString *)contents;

/**
 *  Composer for combining barcode initiator, contents, terminator together.
 *
 *  @param barcode Encoded barcode contents
 *
 *  @return Completed barcode
 */
- (NSString *)completeBarcode:(NSString *)barcode;

/**
 *  Drawer for completed barcode
 *
 *  @param code Completed barcode
 *
 *  @return Encoded image.
 */
- (UIImage *)drawCompleteBarcode:(NSString *)code;

@end

static inline NSString *getFilterName(NSString *codeObjectType) {
    if ([codeObjectType isEqualToString:AVMetadataObjectTypeQRCode]) {
        return @"CIQRCodeGenerator";
    } else if ([codeObjectType isEqualToString:AVMetadataObjectTypePDF417Code]) {
        return @"CIPDF417BarcodeGenerator";
    } else if ([codeObjectType isEqualToString:AVMetadataObjectTypeAztecCode]) {
        return @"CIAztecCodeGenerator";
    }
    return nil;
}

static inline UIImage *genCode(NSString *contents, NSString *filterName) {
    CIFilter *filter = [CIFilter filterWithName:filterName];
    [filter setDefaults];
    NSData *data = [contents dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage *outputImage = [filter outputImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage =
    [context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage *image = [UIImage imageWithCGImage:cgImage
                                         scale:1
                                   orientation:UIImageOrientationUp];
    CGImageRelease(cgImage);
    return image;
}

static inline UIImage *resizeImage(UIImage *source, float scale) {
    CGFloat width = source.size.width * scale;
    CGFloat height = source.size.height * scale;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    [source drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *target = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return target;
}
