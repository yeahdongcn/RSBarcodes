//
//  RSUnifiedCodeGenerator.m
//  RSBarcodes
//
//  Created by R0CKSTAR on 12/25/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "RSUnifiedCodeGenerator.h"

#import "RSCode39Generator.h"

#import "RSCode39Mod43Generator.h"

#import "RSExtendedCode39Generator.h"

#import "RSEAN13Generator.h"

#import "RSEAN8Generator.h"

#import "RSUPCEGenerator.h"

@implementation RSUnifiedCodeGenerator

+ (instancetype)codeGen
{
    static RSUnifiedCodeGenerator *codeGen = nil;
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
    
    id<RSCodeGenerator> codeGen = nil;
    if ([codeObjectType isEqualToString:AVMetadataObjectTypeCode39Code]) {
        codeGen = [[RSCode39Generator alloc] init];
    } else if ([codeObjectType isEqualToString:AVMetadataObjectTypeCode39Mod43Code]) {
        codeGen = [[RSCode39Mod43Generator alloc] init];
    } else if ([codeObjectType isEqualToString:RSMetadataObjectTypeExtendedCode39Code]) {
        codeGen = [[RSExtendedCode39Generator alloc] init];
    } else if ([codeObjectType isEqualToString:AVMetadataObjectTypeEAN13Code]) {
        codeGen = [[RSEAN13Generator alloc] init];
    } else if ([codeObjectType isEqualToString:AVMetadataObjectTypeEAN8Code]) {
        codeGen = [[RSEAN8Generator alloc] init];
    } else if ([codeObjectType isEqualToString:AVMetadataObjectTypeUPCECode]) {
        codeGen = [[RSUPCEGenerator alloc] init];
    }
    
    if (codeGen) {
        return [codeGen encode:contents codeObjectType:codeObjectType];
    } else {
        return nil;
    }
}

@end
