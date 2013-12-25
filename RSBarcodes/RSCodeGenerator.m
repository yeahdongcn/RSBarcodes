//
//  RSCodeGenerator.m
//  RSBarcodes
//
//  Created by R0CKSTAR on 12/25/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "RSCodeGenerator.h"

@implementation RSAbstractCodeGenerator

- (NSString *)initiator
{
    return @"";
}

- (NSString *)terminator
{
    return @"";
}

- (UIImage *)encode:(NSString *)contents codeObjectType:(NSString *)codeObjectType
{
    return nil;
}

@end
