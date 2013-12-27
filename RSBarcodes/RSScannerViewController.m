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

#ifdef DEBUG
#import "RSCodeView.h"
#import "RSCodeGen.h"
#endif

@interface RSScannerViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureSession           *session;
@property (nonatomic, strong) AVCaptureDevice            *device;
@property (nonatomic, strong) AVCaptureDeviceInput       *input;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *layer;
@property (nonatomic, strong) AVCaptureMetadataOutput    *output;

@property (nonatomic, weak) IBOutlet RSCornersView       *highlightView;

#ifdef DEBUG
@property (nonatomic, weak) IBOutlet RSCodeView          *codeView;
#endif

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

- (void)__setup
{
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
    [self.view.layer addSublayer:self.layer];
    
    self.output = [[AVCaptureMetadataOutput alloc] init];
    dispatch_queue_t queue = dispatch_queue_create("com.pdq.RSBarcodes.metadata", 0);
    [self.output setMetadataObjectsDelegate:self queue:queue];
    if ([self.session canAddOutput:self.output]) {
        [self.session addOutput:self.output];
        if (!self.codeObjectTypes) {
            NSMutableArray *codeObjectTypes = [NSMutableArray arrayWithArray:self.output.availableMetadataObjectTypes];
            [codeObjectTypes removeObject:AVMetadataObjectTypeFace];
            self.codeObjectTypes = [NSArray arrayWithArray:codeObjectTypes];
        }
        self.output.metadataObjectTypes = self.codeObjectTypes;
    }
    
    [self.view bringSubviewToFront:self.highlightView];
#ifdef DEBUG
    [self.view bringSubviewToFront:self.codeView];
#endif
}

- (void)__startRunning
{
    if (self.session.isRunning) {
        return;
    }

    [self.session startRunning];
}

- (void)__stopRunning {
    if (!self.session.isRunning) {
        return;
    }
    
    [self.session stopRunning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self __setup];
    
#ifdef DEBUG
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[CodeGen encode:@"code 39" codeObjectType:RSMetadataObjectTypeExtendedCode39Code]];
    [imageView sizeToFit];
    imageView.center = self.view.center;
    [self.view addSubview:imageView];
#endif
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

#pragma mark - AVCaptureMetadataOutputObjectsDelegate

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    for (AVMetadataObject *metadata in metadataObjects) {
        AVMetadataMachineReadableCodeObject *codeObject = (AVMetadataMachineReadableCodeObject *)[self.layer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
        if ([codeObject respondsToSelector:@selector(corners)]) {
            self.highlightView.corners = codeObject.corners;
        }
        /*
        self.highlightView.borderRect = barCodeObject.bounds;
         */
        
#ifdef DEBUG
        NSString *contents = [codeObject stringValue];
        if (![self.codeView.contents isEqualToString:contents]) {
            self.codeView.contents = contents;
            self.codeView.code = [CodeGen encode:contents codeObjectType:[codeObject type]];
        }
#endif
    }
    
    if (metadataObjects.count <= 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.highlightView.corners = nil;
            /*
            self.highlightView.borderRect = CGRectZero;
             */
#ifdef DEBUG
            self.codeView.contents = nil;
            self.codeView.code = nil;
#endif
        });
    }
}

@end
