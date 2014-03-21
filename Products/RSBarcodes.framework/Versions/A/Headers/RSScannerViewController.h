//
//  RSScannerViewController.h
//  RSBarcodes
//
//  Created by R0CKSTAR on 12/19/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import <UIKit/UIKit.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000

extern NSString *const AVMetadataObjectTypeFace;

#endif

@class RSCornersView;

typedef void (^RSBarcodesHandler)(NSArray *barcodeObjects);

typedef void (^RSTapGestureHandler)(CGPoint tapPoint);

@interface RSScannerViewController : UIViewController

@property (nonatomic, strong) NSArray *barcodeObjectTypes;

@property (nonatomic, weak) IBOutlet RSCornersView *highlightView;

@property (nonatomic, copy) RSBarcodesHandler barcodesHandler;

@property (nonatomic, copy) RSTapGestureHandler tapGestureHandler;

@property (nonatomic) BOOL isCornersVisible;     // Default is YES

@property (nonatomic) BOOL isBorderRectsVisible; // Default is NO

@property (nonatomic) BOOL isFocusMarkVisible;   // Default is YES

@end
