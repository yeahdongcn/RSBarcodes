//
//  RSCornersView.h
//  RSBarcodes
//
//  Created by R0CKSTAR on 12/19/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSCornersView : UIView

@property(nonatomic, strong) NSArray *cornersArray;

@property(nonatomic, strong) NSArray *borderRectArray;

@property(nonatomic, copy) UIColor *strokeColor; // Default is green

@property(nonatomic) float strokeWidth; // Default is 2.f

@property(nonatomic) CGPoint focusPoint;

@property(nonatomic) CGSize focusSize; // Default is CGSizeMake(100.f, 100.f)

@property(nonatomic, copy) UIColor *focusStrokeColor; // Default is orange

@property(nonatomic) float focusStrokeWidth; // Default is 1.f

@property(nonatomic) double focusMarkDisplayingDuration; // Default is 1

@end
