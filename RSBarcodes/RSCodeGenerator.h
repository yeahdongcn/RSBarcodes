//
//  RSCodeGenerator.h
//  RSBarcodes
//
//  Created by R0CKSTAR on 12/25/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

@protocol RSCodeGenerator <NSObject>

- (UIImage *)genCodeWithMachineReadableCodeObject:(AVMetadataMachineReadableCodeObject *)machineReadableCodeObject;

- (UIImage *)genCodeWithContents:(NSString *)contents machineReadableCodeObjectType:(NSString *)type;

@end

@protocol RSCheckDigitGenerator <NSObject>

@optional

- (NSString *)checkDigit:(NSString *)contents;

@end

extern NSString * const DIGITS_STRING;

@interface RSAbstractCodeGenerator : NSObject <RSCodeGenerator>

- (BOOL)isContentsValid:(NSString *)contents;

- (NSString *)initiator;

- (NSString *)terminator;

- (NSString *)barcode:(NSString *)contents;

- (NSString *)completeBarcode:(NSString *)barcode;

- (UIImage *)drawCompleteBarcode:(NSString *)code;

@end

static inline NSString* getfilterName(NSString *codeObjectType)
{
    if ([codeObjectType isEqualToString:AVMetadataObjectTypeQRCode]) {
        return @"CIQRCodeGenerator";
    } else if ([codeObjectType isEqualToString:AVMetadataObjectTypePDF417Code]) {
        return @"CIPDF417BarcodeGenerator";
    } else if ([codeObjectType isEqualToString:AVMetadataObjectTypeAztecCode]) {
        return @"CIAztecCodeGenerator";
    }
    return nil;
}

static inline UIImage* genCode(NSString *contents, NSString *filterName)
{
    CIFilter *filter = [CIFilter filterWithName:filterName];
    [filter setDefaults];
    NSData *data = [contents dataUsingEncoding:NSUTF8StringEncoding];
    [filter setValue:data forKey:@"inputMessage"];
    
    CIImage *outputImage = [filter outputImage];
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context createCGImage:outputImage
                                       fromRect:[outputImage extent]];
    UIImage *image = [UIImage imageWithCGImage:cgImage
                                         scale:1.0
                                   orientation:UIImageOrientationUp];
    CGImageRelease(cgImage);
    return image;
}

static inline UIImage *resizeImage(UIImage *source,
                                   float scale,
                                   CGInterpolationQuality quality)
{
    CGFloat width = source.size.width * scale;
    CGFloat height = source.size.height * scale;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [source drawInRect:CGRectMake(0, 0, width, height)];
    UIImage *target = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return target;
}