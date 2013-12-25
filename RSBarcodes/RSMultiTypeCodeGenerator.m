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
    static RSMultiTypeCodeGenerator *codeGen = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        codeGen = [[self alloc] init];
    });
    return codeGen;
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
