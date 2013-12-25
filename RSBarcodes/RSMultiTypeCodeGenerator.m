//
//  RSMultiTypeCodeGenerator.m
//  RSBarcodes
//
//  Created by R0CKSTAR on 12/25/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "RSMultiTypeCodeGenerator.h"

@implementation RSMultiTypeCodeGenerator

+ (instancetype)codeGen
{
    return [[RSMultiTypeCodeGenerator alloc] init];
}

- (UIImage *)encode:(NSString *)contents type:(NSString *)type
{
    if ([type isEqualToString:AVMetadataObjectTypeQRCode]
        || [type isEqualToString:AVMetadataObjectTypePDF417Code]
        || [type isEqualToString:AVMetadataObjectTypeAztecCode]) {
        return genCode(contents, filterName(type));
    }
    return nil;
}

@end
