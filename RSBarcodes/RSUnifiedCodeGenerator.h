//
//  RSUnifiedCodeGenerator.m
//  RSBarcodes
//
//  Created by R0CKSTAR on 12/25/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RSCodeGenerator.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000

extern NSString *const AVMetadataObjectTypeUPCECode;
extern NSString *const AVMetadataObjectTypeCode39Code;
extern NSString *const AVMetadataObjectTypeCode39Mod43Code;
extern NSString *const AVMetadataObjectTypeEAN13Code;
extern NSString *const AVMetadataObjectTypeEAN8Code;
extern NSString *const AVMetadataObjectTypeCode93Code;
extern NSString *const AVMetadataObjectTypeCode128Code;
extern NSString *const AVMetadataObjectTypePDF417Code;
extern NSString *const AVMetadataObjectTypeQRCode;
extern NSString *const AVMetadataObjectTypeAztecCode;

#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000

extern NSString *const AVMetadataObjectTypeInterleaved2of5Code;
extern NSString *const AVMetadataObjectTypeITF14Code;

#endif

@interface RSUnifiedCodeGenerator : NSObject <RSCodeGenerator>

+ (instancetype)codeGen;

@end
