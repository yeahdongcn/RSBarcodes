//
//  RSEANGenerator.h
//  RSBarcodes
//
//  Created by zhangxi on 14-1-6.
//  http://zhangxi.me
//  Copyright (c) 2014年 P.D.Q. All rights reserved.
//

#import "RSCodeGenerator.h"

@interface RSEANGenerator : RSAbstractCodeGenerator
{
    NSArray *codeTypes;
    NSArray *codeMap;
    int length;
}

@end
