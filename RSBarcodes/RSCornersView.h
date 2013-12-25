//
//  RSCornersView.h
//  RSBarcodes
//
//  Created by R0CKSTAR on 12/19/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSCornersView : UIView

@property (nonatomic, copy) NSArray *corners;

@property (nonatomic) CGRect borderRect;

@property (nonatomic, copy) UIColor *strokeColor; // Default is green.

@property (nonatomic) float strokeWidth; // Default is 1.0.

@end
