//
//  MainViewController.m
//  RSBarcodesSample
//
//  Created by Albert Stark on 13.07.14.
//  Copyright (c) 2014 P.D.Q. All rights reserved.
//

#import "MainViewController.h"


@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    scanner = [[RSScannerViewController alloc] initWithCornerView:YES
                                                      controlView:YES
                                                  barcodesHandler:^(NSArray *barcodeObjects) {
                                                      [self dismissViewControllerAnimated:true completion:nil];
                                                      [self.navigationController popViewControllerAnimated:YES];
                                                  }
               preferredCameraPosition:AVCaptureDevicePositionBack];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (IBAction)presentModal:(id)sender {
    [self presentViewController:scanner animated:YES completion:nil];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
