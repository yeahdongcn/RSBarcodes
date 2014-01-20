//
//  RSUPCEGenerator.h
//  RSBarcodes
//
//  Created by R0CKSTAR on 12/27/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "RSCodeGenerator.h"

/**
 *  http://www.sly.com.tw/skill/know/new_page_6.htm
 *  http://mdn.morovia.com/kb/UPCE-Specification-10634.html
 *  http://mdn.morovia.com/kb/UPCA-Specification-10632.html
 *  http://www.barcodeisland.com/upce.phtml
 */
@interface RSUPCEGenerator : RSAbstractCodeGenerator <RSCheckDigitGenerator>

@end
