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

#import "RSCode93Generator.h"

#import "RSCode128Generator.h"

#import "RSISBN13Generator.h"

#import "RSISSN13Generator.h"

#import "RSITFGenerator.h"

#import "RSITF14Generator.h"

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 70000

NSString *const AVMetadataObjectTypeUPCECode            = @"org.gs1.UPC-E";
NSString *const AVMetadataObjectTypeCode39Code          = @"org.iso.Code39";
NSString *const AVMetadataObjectTypeCode39Mod43Code     = @"org.iso.Code39Mod43";
NSString *const AVMetadataObjectTypeEAN13Code           = @"org.gs1.EAN-13";
NSString *const AVMetadataObjectTypeEAN8Code            = @"org.gs1.EAN-8";
NSString *const AVMetadataObjectTypeCode93Code          = @"com.intermec.Code93";
NSString *const AVMetadataObjectTypeCode128Code         = @"org.iso.Code128";
NSString *const AVMetadataObjectTypePDF417Code          = @"org.iso.PDF417";
NSString *const AVMetadataObjectTypeQRCode              = @"org.iso.QRCode";
NSString *const AVMetadataObjectTypeAztecCode           = @"org.iso.Aztec";

#endif

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 80000

NSString *const AVMetadataObjectTypeInterleaved2of5Code = @"org.ansi.Interleaved2of5";
NSString *const AVMetadataObjectTypeITF14Code           = @"org.gs1.ITF14";

#endif

@implementation RSUnifiedCodeGenerator

@synthesize strokeColor = _strokeColor, fillColor = _fillColor;

+ (instancetype)codeGen {
    static RSUnifiedCodeGenerator *codeGen = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ codeGen = [[self alloc] init]; });
    return codeGen;
}

#pragma mark - RSCodeGenerator

- (UIImage *)genCodeWithContents:(NSString *)contents
   machineReadableCodeObjectType:(NSString *)type {
    if ([type isEqualToString:AVMetadataObjectTypeQRCode] ||
        [type isEqualToString:AVMetadataObjectTypePDF417Code] ||
        [type isEqualToString:AVMetadataObjectTypeAztecCode]) {
        if (([[[UIDevice currentDevice] systemVersion] compare:@"6.0"
                                                       options:NSNumericSearch] !=
             NSOrderedAscending)) {
            return genCode(contents, getFilterName(type));
        }
    }
    
    id<RSCodeGenerator> codeGen = nil;
    if ([type isEqualToString:AVMetadataObjectTypeCode39Code]) {
        codeGen = [[RSCode39Generator alloc] init];
        
    } else if ([type isEqualToString:AVMetadataObjectTypeCode39Mod43Code]) {
        codeGen = [[RSCode39Mod43Generator alloc] init];
        
    } else if ([type isEqualToString:AVMetadataObjectTypeEAN13Code]) {
        codeGen = [[RSEAN13Generator alloc] init];
        
    } else if ([type isEqualToString:AVMetadataObjectTypeEAN8Code]) {
        codeGen = [[RSEAN8Generator alloc] init];
        
    } else if ([type isEqualToString:AVMetadataObjectTypeUPCECode]) {
        codeGen = [[RSUPCEGenerator alloc] init];
        
    } else if ([type isEqualToString:AVMetadataObjectTypeCode93Code]) {
        codeGen = [[RSCode93Generator alloc] init];
        
    } else if ([type isEqualToString:AVMetadataObjectTypeCode128Code]) {
        codeGen = [[RSCode128Generator alloc] initWithContents:contents];
        
    } else if ([type isEqualToString:AVMetadataObjectTypeInterleaved2of5Code]) {
        codeGen = [[RSITFGenerator alloc] init];
        
    } else if ([type isEqualToString:AVMetadataObjectTypeITF14Code]) {
        codeGen = [[RSITF14Generator alloc] init];
        
    } else if ([type isEqualToString:RSMetadataObjectTypeExtendedCode39Code]) {
        codeGen = [[RSExtendedCode39Generator alloc] init];
        
    } else if ([type isEqualToString:RSMetadataObjectTypeISBN13Code]) {
        codeGen = [[RSISBN13Generator alloc] init];
        
    } else if ([type isEqualToString:RSMetadataObjectTypeISSN13Code]) {
        codeGen = [[RSISSN13Generator alloc] init];
        
    }
    
    if (codeGen) {
        codeGen.fillColor = self.fillColor;
        codeGen.strokeColor = self.strokeColor;
        
        return [codeGen genCodeWithContents:contents
              machineReadableCodeObjectType:type];
    } else {
        return nil;
    }
}

- (UIImage *)genCodeWithMachineReadableCodeObject:
(AVMetadataMachineReadableCodeObject *)
machineReadableCodeObject {
    return [self genCodeWithContents:[machineReadableCodeObject stringValue]
       machineReadableCodeObjectType:[machineReadableCodeObject type]];
}

@end
