//
//  RSITF14Generator.m
//  RSBarcodesSample
//
//  Created by R0CKSTAR on 3/17/14.
//  Copyright (c) 2014 P.D.Q. All rights reserved.
//

#import "RSITF14Generator.h"

@implementation RSITF14Generator

- (BOOL)isContentsValid:(NSString *)contents {
    return ([super isContentsValid:contents] && [contents length] == 14);
}

@end
