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

@property (nonatomic, strong) AVCaptureSession           *session;
@property (nonatomic, strong) AVCaptureDevice            *device;
@property (nonatomic, strong) AVCaptureDeviceInput       *input;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *layer;
@property (nonatomic, strong) AVCaptureMetadataOutput    *output;

@end

@implementation RSScannerViewController

#pragma mark - Private

- (void)__applicationWillEnterForeground:(NSNotification *)notification
{
    [self __startRunning];
}

- (void)__applicationDidEnterBackground:(NSNotification *)notification
{
    [self __stopRunning];
}

- (void)__handleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer
{
    CGPoint tapPoint = [tapGestureRecognizer locationInView:self.view];
    CGPoint focusPoint= CGPointMake(tapPoint.x / self.view.bounds.size.width, tapPoint.y / self.view.bounds.size.height);
    
    if (!self.device
        && ![self.device isFocusPointOfInterestSupported]
        && ![self.device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
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

- (void)__setup
{
    self.isCornersVisible = YES;
    self.isBorderRectsVisible = NO;
    self.isFocusMarkVisible = YES;
    
    if (self.session) {
        return;
    }
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!self.device) {
        NSLog(@"No video camera on this device!");
        return;
    }
    
    self.session = [[AVCaptureSession alloc] init];
    NSError *error = nil;
    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:self.device error:&error];
    if (error) {
        NSLog(@"%@", error);
        return;
    }
    
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    self.layer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    self.layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.layer.frame = self.view.bounds;
    
    self.output = [[AVCaptureMetadataOutput alloc] init];
    dispatch_queue_t queue = dispatch_queue_create("com.pdq.RSBarcodes.metadata", 0);
    [self.output setMetadataObjectsDelegate:self queue:queue];
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
        if (!self.barcodeObjectTypes) {
            NSMutableArray *codeObjectTypes = [NSMutableArray arrayWithArray:self.output.availableMetadataObjectTypes];
            [codeObjectTypes removeObject:AVMetadataObjectTypeFace];
            self.barcodeObjectTypes = [NSArray arrayWithArray:codeObjectTypes];
        }
        self.output.metadataObjectTypes = self.barcodeObjectTypes;
    }
    
    [self.view bringSubviewToFront:self.highlightView];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__handleTapGesture:)];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)__startRunning
{
    if (self.session.isRunning) {
        return;
    }
    
    [self.view.layer addSublayer:self.layer];
    [self.view bringSubviewToFront:self.highlightView];
    
    [self.session startRunning];
}

- (void)__stopRunning {
    if (!self.session.isRunning) {
        return;
    }
    
    [self.layer removeFromSuperlayer];
    
    [self.session stopRunning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self __setup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(__applicationWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(__applicationDidEnterBackground:)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    
    [self __startRunning];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification
                                                  object:nil];
    
    [self __stopRunning];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    NSMutableArray *barcodeObjects  = nil;
    NSMutableArray *cornersArray    = nil;
    NSMutableArray *borderRectArray = nil;
    
    for (AVMetadataObject *metadataObject in metadataObjects) {
        AVMetadataObject *transformedMetadataObject = [self.layer transformedMetadataObjectForMetadataObject:metadataObject];
        if ([transformedMetadataObject isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            AVMetadataMachineReadableCodeObject *barcodeObject = (AVMetadataMachineReadableCodeObject *)transformedMetadataObject;
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
                    [borderRectArray addObject:[NSValue valueWithCGRect:barcodeObject.bounds]];
                }
            }
        }
    }
    
    if (self.isCornersVisible) {
        self.highlightView.cornersArray = cornersArray ? [NSArray arrayWithArray:cornersArray] : nil;
    }
    
    if (self.isBorderRectsVisible) {
        self.highlightView.borderRectArray = borderRectArray ? [NSArray arrayWithArray:borderRectArray] : nil;
    }
    
    if (self.barcodesHandler) {
        self.barcodesHandler([NSArray arrayWithArray:barcodeObjects]);
    }
}

@end
