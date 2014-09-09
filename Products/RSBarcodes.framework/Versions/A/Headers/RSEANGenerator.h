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

@property(nonatomic) int length;

@property(nonatomic, readonly) NSArray *lefthandParities;

@property(nonatomic, readonly) NSArray *parityEncodingTable;

@end
