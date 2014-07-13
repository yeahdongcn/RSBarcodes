//
//  MainViewController.m
//  RSBarcodesSample
//
//  Created by Albert Stark on 13.07.14.
//  Copyright (c) 2014 P.D.Q. All rights reserved.
//

#import "MainViewController.h"
#import "RSBarcodes.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self performSelector:@selector(presentScanner) withObject:nil afterDelay:3];
}

- (void)presentScanner {
    RSScannerViewController *scanner = [[RSScannerViewController alloc] initWithCornerView:YES
                                                                               controlView:YES
                                                                           barcodesHandler:^(NSArray *barcodeObjects) {
                                                                               [self dismissViewControllerAnimated:true
                                                                                                        completion:nil];
                                                                           }
                                                                   preferredCameraPosition:AVCaptureDevicePositionFront];
    [self presentViewController:scanner animated:true completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
