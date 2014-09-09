//
//  RSScannerViewController.h
//  RSBarcodes
//
//  Created by R0CKSTAR on 12/19/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000

extern NSString *const AVMetadataObjectTypeFace;

#endif

@class RSCornersView;

typedef void (^RSBarcodesHandler)(NSArray *barcodeObjects);

typedef void (^RSTapGestureHandler)(CGPoint tapPoint);

@interface RSScannerViewController : UIViewController {
}

@property(nonatomic) AVCaptureDevicePosition preferredCameraPosition;

@property(nonatomic) BOOL torchState;

@property(nonatomic) BOOL stopOnFirst;

@property(nonatomic, strong) NSArray *barcodeObjectTypes;

@property(nonatomic, strong) IBOutlet RSCornersView *highlightView;

@property(nonatomic, strong) IBOutlet UIView *controlsView;

@property(strong, nonatomic) IBOutlet UIButton *flipButton;

@property(strong, nonatomic) IBOutlet UIButton *cancelButton;

@property(strong, nonatomic) IBOutlet UIButton *torchButton;

@property(strong, nonatomic) IBOutlet UIView *sidebarView;

@property(nonatomic, copy) RSBarcodesHandler barcodesHandler;

@property(nonatomic, copy) RSTapGestureHandler tapGestureHandler;

@property(nonatomic) BOOL isCornersVisible; // Default is YES

@property(nonatomic) BOOL isBorderRectsVisible; // Default is NO

@property(nonatomic) BOOL isFocusMarkVisible; // Default is YES

@property(nonatomic) BOOL isControlsVisible; // Default is YES

@property(nonatomic) BOOL isButtonBordersVisible; // Default is YES

- (id)initWithCornerView:(BOOL)showCornerView
             controlView:(BOOL)showControlsView
         barcodesHandler:(RSBarcodesHandler)barcodesHandler;
- (id)initWithCornerView:(BOOL)showCornerView
             controlView:(BOOL)showControlsView
         barcodesHandler:(RSBarcodesHandler)barcodesHandler
 preferredCameraPosition:(AVCaptureDevicePosition)cameraDevicePosition;
- (void)updateView;
- (void)startRunning;
- (void)stopRunning;

@end
