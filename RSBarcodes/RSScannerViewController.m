//
//  RSScannerViewController.m
//  RSBarcodes
//
//  Created by R0CKSTAR on 12/19/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "RSScannerViewController.h"

#import "RSCornersView.h"

#import <AVFoundation/AVFoundation.h>

#if __IPHONE_OS_VERSION_MIN_REQUIRED < 60000

NSString *const AVMetadataObjectTypeFace = @"face";

#endif

@interface RSScannerViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property(nonatomic, strong) AVCaptureSession *session;
@property(nonatomic, strong) AVCaptureDevice *device;
@property(nonatomic, strong) AVCaptureDeviceInput *input;
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *layer;
@property(nonatomic, strong) AVCaptureMetadataOutput *output;

@end

@implementation RSScannerViewController

#pragma mark - Private

- (AVCaptureVideoOrientation)__interfaceOrientationToVideoOrientation:(UIInterfaceOrientation)orientation {
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            return AVCaptureVideoOrientationPortraitUpsideDown;
        case UIInterfaceOrientationLandscapeLeft:
            return AVCaptureVideoOrientationLandscapeLeft;
        case UIInterfaceOrientationLandscapeRight:
            return AVCaptureVideoOrientationLandscapeRight;
        default:
            return AVCaptureVideoOrientationPortrait;
    }
}

- (void)__applicationWillEnterForeground:(NSNotification *)notification {
    [self startRunning];
}

- (void)__applicationDidEnterBackground:(NSNotification *)notification {
    [self stopRunning];
}

- (void)__handleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer {
    CGPoint tapPoint = [tapGestureRecognizer locationInView:self.view];
    CGPoint focusPoint = CGPointMake(tapPoint.x / self.view.bounds.size.width,
                                     tapPoint.y / self.view.bounds.size.height);
    
    if (!self.device || ![self.device isFocusPointOfInterestSupported] ||
        ![self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        return;
    } else if ([self.device lockForConfiguration:nil]) {
        [self.device setFocusPointOfInterest:focusPoint];
        [self.device setFocusMode:AVCaptureFocusModeAutoFocus];
        [self.device unlockForConfiguration];
        
        if (self.isFocusMarkVisible) {
            self.highlightView.focusPoint = tapPoint;
        }
        
        if (self.tapGestureHandler) {
            self.tapGestureHandler(tapPoint);
        }
    }
}

- (void)__setup {
    self.isCornersVisible = YES;
    self.isBorderRectsVisible = NO;
    self.isFocusMarkVisible = YES;
    
    if (self.session) {
        return;
    }
    
    if (self.preferredCameraPosition) {
        NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        for (AVCaptureDevice *device in devices) {
            if ([device position] == self.preferredCameraPosition) {
                self.device = device;
            }
        }
    } else {
        self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if (!self.device) {
            NSLog(@"No video camera on this device!");
            return;
        }
    }
    
    self.session = [[AVCaptureSession alloc] init];
    NSError *error = nil;
    self.input =
    [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:&error];
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    self.layer =
    [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.layer.frame = self.view.bounds;
    [self.view.layer addSublayer:self.layer];
    
    self.output = [[AVCaptureMetadataOutput alloc] init];
    dispatch_queue_t queue =
    dispatch_queue_create("com.pdq.RSBarcodes.metadata", 0);
    [self.output setMetadataObjectsDelegate:self queue:queue];
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
        if (!self.barcodeObjectTypes) {
            NSMutableArray *codeObjectTypes = [NSMutableArray
                                               arrayWithArray:self.output.availableMetadataObjectTypes];
            [codeObjectTypes removeObject:AVMetadataObjectTypeFace];
            self.barcodeObjectTypes = [NSArray arrayWithArray:codeObjectTypes];
        }
        self.output.metadataObjectTypes = self.barcodeObjectTypes;
    }
    
    [self.view bringSubviewToFront:self.highlightView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(__handleTapGesture:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (BOOL)__isModal {
    if ([self presentingViewController])
        return YES;
    if ([[self presentingViewController] presentedViewController] == self)
        return YES;
    if ([[[self navigationController] presentingViewController] presentedViewController] ==
        [self navigationController])
        return YES;
    if ([[[self tabBarController] presentingViewController]
         isKindOfClass:[UITabBarController class]])
        return YES;
    
    return NO;
}

- (void)__exit {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:true completion:nil];
    });
}

#pragma mark - Setter

- (void)setTorchState:(BOOL)torchState {
    dispatch_async(dispatch_get_main_queue(), ^{
        // set button
        // yellow when
        // torch is on
        [self.torchButton setTitleColor:(torchState ? [UIColor colorWithRed:1.0f
                                                                      green:0.79f
                                                                       blue:0.28f
                                                                      alpha:1.0f]
                                         : [UIColor whiteColor])
                               forState:UIControlStateNormal];
        [self.torchButton.layer setBorderColor:(torchState ? [UIColor colorWithRed:1.0f
                                                                             green:0.79f
                                                                              blue:0.28f
                                                                             alpha:1.0f].CGColor
                                                : [UIColor whiteColor].CGColor)];
    });
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch]) {
        [device lockForConfiguration:nil];
        [device
         setTorchMode:torchState ? AVCaptureTorchModeOn : AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
    
    _torchState = torchState;
}

#pragma mark - Initialization

- (id)initWithCornerView:(BOOL)showCornerView
             controlView:(BOOL)showControlsView
         barcodesHandler:(RSBarcodesHandler)barcodesHandler {
    if ((self = [super init])) {
        if (!self.highlightView && showCornerView) {
            RSCornersView *cornerView =
            [[RSCornersView alloc] initWithFrame:self.view.frame];
            cornerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self.view addSubview:cornerView];
            [self.view bringSubviewToFront:cornerView];
            
            self.highlightView = cornerView;
            
            self.isControlsVisible = showCornerView;
        }
        
        if (!self.controlsView && showControlsView) {
            UIView *controlsView = [[UIView alloc] initWithFrame:self.view.frame];
            controlsView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self.view addSubview:controlsView];
            [self.view bringSubviewToFront:controlsView];
            
            self.controlsView = controlsView;
            self.isControlsVisible = showControlsView;
            
            self.isButtonBordersVisible = false;
            
            [self updateView];
        }
        
        self.barcodesHandler = barcodesHandler;
        
        self.tapGestureHandler = ^(CGPoint tapPoint) {};
    }
    
    return self;
}

- (id)initWithCornerView:(BOOL)showCornerView
             controlView:(BOOL)showControlsView
         barcodesHandler:(RSBarcodesHandler)barcodesHandler
 preferredCameraPosition:(AVCaptureDevicePosition)cameraDevicePosition {
    self.preferredCameraPosition = cameraDevicePosition;
    
    return [self initWithCornerView:showCornerView
                        controlView:showControlsView
                    barcodesHandler:barcodesHandler];
}

#pragma mark - View lifecycle

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    AVCaptureVideoOrientation target = [self __interfaceOrientationToVideoOrientation:[[UIApplication sharedApplication] statusBarOrientation]];
    AVCaptureVideoOrientation source = self.layer.connection.videoOrientation;
    if (self.layer.connection.supportsVideoOrientation && source != target) {
        self.layer.connection.videoOrientation = target;
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    CGRect frame = CGRectMake(0, 0, size.width, size.height);
    self.layer.frame = frame;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self __setup];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(__applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(__applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [self startRunning];
    [self updateView];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
    
    [self stopRunning];
}

- (BOOL)shouldAutorotate {
    [self updateView];
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputMetadataObjects:(NSArray *)metadataObjects
       fromConnection:(AVCaptureConnection *)connection {
    if (self.stopOnFirst) {
        [self stopRunning];
    }
    
    NSMutableArray *barcodeObjects = nil;
    NSMutableArray *cornersArray = nil;
    NSMutableArray *borderRectArray = nil;
    
    for (AVMetadataObject *metadataObject in metadataObjects) {
        AVMetadataObject *transformedMetadataObject =
        [self.layer transformedMetadataObjectForMetadataObject:metadataObject];
        if ([transformedMetadataObject
             isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            AVMetadataMachineReadableCodeObject *barcodeObject =
            (AVMetadataMachineReadableCodeObject *)transformedMetadataObject;
            if (!barcodeObjects) {
                barcodeObjects = [[NSMutableArray alloc] init];
            }
            [barcodeObjects addObject:barcodeObject];
            
            if (self.isCornersVisible) {
                if ([barcodeObject respondsToSelector:@selector(corners)]) {
                    if (!cornersArray) {
                        cornersArray = [[NSMutableArray alloc] init];
                    }
                    [cornersArray addObject:barcodeObject.corners];
                }
            }
            
            if (self.isBorderRectsVisible) {
                if ([barcodeObject respondsToSelector:@selector(bounds)]) {
                    if (!borderRectArray) {
                        borderRectArray = [[NSMutableArray alloc] init];
                    }
                    [borderRectArray
                     addObject:[NSValue valueWithCGRect:barcodeObject.bounds]];
                }
            }
        }
    }
    
    if (self.isCornersVisible) {
        self.highlightView.cornersArray =
        cornersArray ? [NSArray arrayWithArray:cornersArray] : nil;
    }
    
    if (self.isBorderRectsVisible) {
        self.highlightView.borderRectArray =
        borderRectArray ? [NSArray arrayWithArray:borderRectArray] : nil;
    }
    
    if (self.barcodesHandler) {
        self.barcodesHandler([NSArray arrayWithArray:barcodeObjects]);
    }
    
    if (self.stopOnFirst) {
        [self startRunning];
    }
}

#pragma mark - Public

- (void)startRunning {
    if (self.session.isRunning) {
        return;
    }
    [self.session startRunning];
}

- (void)stopRunning {
    if (!self.session.isRunning) {
        return;
    }
    [self.session stopRunning];
    
    self.highlightView.cornersArray = nil;
    self.highlightView.borderRectArray = nil;
    [self.highlightView setNeedsDisplay];
}

- (void)updateView {
    if (!self.isControlsVisible) {
        return;
    }
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    CGRect flipButtonRect;
    CGRect cancelButtonRect;
    CGRect torchButtonRect;
    CGRect sidebarRect;
    
    CGFloat rotationAngle = 0;
    
    CGSize viewSize = self.view.frame.size;
    
    if (!self.sidebarView) {
        self.sidebarView = [[UIView alloc] init];
        [self.sidebarView
         setBackgroundColor:
         [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.9f]];
        
        [self.controlsView addSubview:self.sidebarView];
        [self.controlsView bringSubviewToFront:self.sidebarView];
    }
    
    if (!self.cancelButton && [self __isModal]) {
        self.cancelButton = [[UIButton alloc] init];
        [self.cancelButton setTitle:@" cancel " forState:UIControlStateNormal];
        [self.cancelButton
         setTitleColor:
         [UIColor colorWithRed:1.0f green:0.22f blue:0.22f alpha:1.0f]
         forState:UIControlStateNormal];
        [self.cancelButton setContentHorizontalAlignment:
         UIControlContentHorizontalAlignmentCenter];
        [self.cancelButton addTarget:self
                              action:@selector(__exit)
                    forControlEvents:UIControlEventTouchDown];
        
        [self.controlsView addSubview:self.cancelButton];
        [self.controlsView bringSubviewToFront:self.cancelButton];
    }
    
    if (![self __isModal]) {
        [self.cancelButton removeFromSuperview];
    }
    
    if (!self.flipButton &&
        ([UIImagePickerController
          isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront] &&
         [UIImagePickerController
          isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear])) {
             self.flipButton = [[UIButton alloc] init];
             [self.flipButton setTitle:@" flip " forState:UIControlStateNormal];
             [self.flipButton setContentHorizontalAlignment:
              UIControlContentHorizontalAlignmentCenter];
             
             [self.flipButton addTarget:self
                                 action:@selector(switchCamera)
                       forControlEvents:UIControlEventTouchDown];
             
             [self.controlsView addSubview:self.flipButton];
             [self.controlsView bringSubviewToFront:self.flipButton];
         }
    
    if (!self.torchButton && [self.device hasTorch]) {
        self.torchButton = [[UIButton alloc] init];
        [self.torchButton setTitle:@" torch " forState:UIControlStateNormal];
        [self.torchButton setContentHorizontalAlignment:
         UIControlContentHorizontalAlignmentCenter];
        
        [self.torchButton addTarget:self
                             action:@selector(toggleTorch)
                   forControlEvents:UIControlEventTouchDown];
        
        [self.controlsView addSubview:self.torchButton];
        [self.controlsView bringSubviewToFront:self.torchButton];
    }
    
    if (self.isButtonBordersVisible) {
        [self.cancelButton.layer setCornerRadius:8.0f];
        [self.cancelButton.layer setBorderColor:[UIColor redColor].CGColor];
        [self.cancelButton.layer setBorderWidth:1.5f];
        
        [self.flipButton.layer setCornerRadius:8.0f];
        [self.flipButton.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self.flipButton.layer setBorderWidth:1.5f];
        
        [self.torchButton.layer setCornerRadius:8.0f];
        [self.torchButton.layer setBorderColor:[UIColor whiteColor].CGColor];
        [self.torchButton.layer setBorderWidth:1.5f];
    } else {
        [self.cancelButton.layer setBorderWidth:0.f];
        
        [self.flipButton.layer setBorderWidth:0.f];
        
        [self.torchButton.layer setBorderWidth:0.f];
    }
    
    switch (UI_USER_INTERFACE_IDIOM()) {
        case UIUserInterfaceIdiomPad: {
            sidebarRect = CGRectMake(self.view.frame.size.width - 110, 0, 110,
                                     self.view.frame.size.height);
            flipButtonRect = CGRectMake(viewSize.width - 70, 30, 56, 20);
            cancelButtonRect = CGRectMake(self.view.frame.size.width - 80,
                                          viewSize.height - 40, 56, 30);
            
            if (orientation == 0) { // Default orientation
                // failsafe
            } else if (orientation == UIInterfaceOrientationPortrait) {
            } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            } else if (orientation == UIInterfaceOrientationLandscapeLeft ||
                       orientation == UIInterfaceOrientationLandscapeRight) {
                flipButtonRect = CGRectMake(viewSize.width - 80, 30, 56, 20);
                cancelButtonRect = CGRectMake(self.view.frame.size.width - 80,
                                              viewSize.height - 60, 56, 42);
            }
        } break;
            
        case UIUserInterfaceIdiomPhone: {
            const int marginToTop = 22;
            
            sidebarRect = CGRectMake(0, 0, viewSize.width, marginToTop + 40);
            flipButtonRect = CGRectMake(viewSize.width - 40, marginToTop, 30, 20);
            torchButtonRect = CGRectMake(viewSize.width / 2 - 24, marginToTop, 30, 20);
            cancelButtonRect = CGRectMake(5, marginToTop, 50, 30);
            
            if (orientation == 0) { // Default orientation
                // failsafe
            } else if (orientation == UIInterfaceOrientationPortrait) {
            } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            } else if (orientation == UIInterfaceOrientationLandscapeLeft ||
                       orientation == UIInterfaceOrientationLandscapeRight) {
                sidebarRect = CGRectMake(0, 0, viewSize.width, marginToTop + 70);
                
                const int rotateMargin = 15;
                flipButtonRect =
                CGRectMake(viewSize.width - 40, marginToTop + rotateMargin, 30, 20);
                torchButtonRect = CGRectMake(viewSize.width / 2 - 16,
                                             marginToTop + rotateMargin, 30, 30);
                cancelButtonRect = CGRectMake(5, marginToTop + rotateMargin, 30, 30);
            }
        } break;
            
        default:
            break;
    }
    
    if (orientation == UIDeviceOrientationPortraitUpsideDown)
        rotationAngle = M_PI;
    else if (orientation == UIDeviceOrientationLandscapeLeft)
        rotationAngle = M_PI_2;
    else if (orientation == UIDeviceOrientationLandscapeRight)
        rotationAngle = -M_PI_2;
    [UIView animateWithDuration:0.5
                     animations:^{
                         [self.sidebarView setFrame:sidebarRect];
                         [self.flipButton setFrame:flipButtonRect];
                         [self.cancelButton setFrame:cancelButtonRect];
                         if ([self __isModal]) {
                             [self.torchButton setFrame:torchButtonRect];
                         } else {
                             [self.torchButton setFrame:cancelButtonRect];
                         }
                     }
                     completion:nil];
    
    [self.flipButton sizeToFit];
    [self.cancelButton sizeToFit];
    [self.torchButton sizeToFit];
}

- (void)switchCamera {
    CATransition *animation = [CATransition animation];
    animation.duration = .5f;
    animation.timingFunction = [CAMediaTimingFunction
                                functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.type = @"oglFlip";
    
    for (AVCaptureDevice *d in
         [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if (d.position != _device.position) {
            [self stopRunning];
            _device = d;
            
            AVCaptureDeviceInput *oldInput = _input;
            [_session removeInput:oldInput];
            
            _input = [[AVCaptureDeviceInput alloc] initWithDevice:_device error:nil];
            
            if ([_session canAddInput:_input]) {
                [_session addInput:_input];
                
                [self setTorchState:false];
                
                if (self.device.position == AVCaptureDevicePositionFront) {
                    animation.subtype = kCATransitionFromRight;
                } else if (self.device.position == AVCaptureDevicePositionBack) {
                    animation.subtype = kCATransitionFromLeft;
                }
                [self.layer addAnimation:animation forKey:nil];
            } else {
                [_session addInput:oldInput];
            }
            
            [self startRunning];
            break;
        }
    }
}

- (void)toggleTorch {
    [self setTorchState:!self.torchState];
}

@end
