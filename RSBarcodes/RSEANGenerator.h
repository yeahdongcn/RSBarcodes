//
//  RSEANGenerator.h
//  RSBarcodes
//
//  Created by zhangxi on 14-1-6.
//  http://zhangxi.me
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

#import "RSCodeGenerator.h"

/**
 *  Base class for EAN8 and EAN13
 */
@interface RSEANGenerator : RSAbstractCodeGenerator
{
    NSArray *codeTypes;
    NSArray *codeMap;
    int length;
}

@end
