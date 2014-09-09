//
//  RSCode128Generator.h
//  RSBarcodes
//
//  Created by R0CKSTAR on 12/30/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "RSCodeGenerator.h"

typedef NS_ENUM(NSUInteger, RSCode128GeneratorCodeTable) {
    RSCode128GeneratorCodeTableAuto = 0,
    RSCode128GeneratorCodeTableA = 1,
    RSCode128GeneratorCodeTableB = 2,
    RSCode128GeneratorCodeTableC = 3
};

/**
 *  http://www.barcodeisland.com/code128.phtml
 *  http://courses.cs.washington.edu/courses/cse370/01au/minirproject/BarcodeBattlers/barcodes.html
 */
@interface RSCode128Generator : RSAbstractCodeGenerator <RSCheckDigitGenerator>

- (id)initWithContents:(NSString *)contents;

@property(nonatomic) RSCode128GeneratorCodeTable codeTable;

@end
