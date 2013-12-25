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

- (UIImage *)encode:(NSString *)contents codeObjectType:(NSString *)codeObjectType
{
    if ([codeObjectType isEqualToString:AVMetadataObjectTypeQRCode]
        || [codeObjectType isEqualToString:AVMetadataObjectTypePDF417Code]
        || [codeObjectType isEqualToString:AVMetadataObjectTypeAztecCode]) {
        return genCode(contents, getfilterName(codeObjectType));
    }
    return nil;
}

@end
