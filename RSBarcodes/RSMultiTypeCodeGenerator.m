//
//  RSMultiTypeCodeGenerator.m
//  RSBarcodesSample
//
//  Created by R0CKSTAR on 12/25/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "RSMultiTypeCodeGenerator.h"

@implementation RSMultiTypeCodeGenerator

+ (instancetype)generator
{
    return [[RSMultiTypeCodeGenerator alloc] init];
}

- (UIImage *)encode:(NSString *)contents type:(NSString *)type
{
    if ([type isEqualToString:AVMetadataObjectTypeQRCode]
        || [type isEqualToString:AVMetadataObjectTypePDF417Code]
        || [type isEqualToString:AVMetadataObjectTypeAztecCode]) {
        return genCode(contents, type);
    }
    return nil;
}

@end
