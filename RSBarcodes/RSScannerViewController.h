//
//  RSScannerViewController.h
//  RSBarcodes
//
//  Created by R0CKSTAR on 12/19/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RSCornersView;

@interface RSScannerViewController : UIViewController

@property (nonatomic, copy) NSArray *codeObjectTypes;

@property (nonatomic, weak) IBOutlet RSCornersView *highlightView;

@end
