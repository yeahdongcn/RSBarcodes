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
                                                        if (barcodeObjects.count > 0) {
                                                              [barcodeObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                                                                  dispatch_async(dispatch_get_main_queue(), ^{
                                                                      AVMetadataMachineReadableCodeObject *code = obj;
                                                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Barcode found"
                                                                                                                      message:code.stringValue
                                                                                                                     delegate:self
                                                                                                            cancelButtonTitle:@"OK"
                                                                                                            otherButtonTitles:nil];
                                                                      //[scanner dismissViewControllerAnimated:true completion:nil];
                                                                      //[scanner.navigationController popViewControllerAnimated:YES];
                                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                                          [scanner dismissViewControllerAnimated:true completion:nil];
                                                                          [alert show];
                                                                      });
                                                                  });
                                                              }];
                                                          }
                                                      
                                                  }
    
                                          preferredCameraPosition:AVCaptureDevicePositionBack];
    
    [scanner setIsButtonBordersVisible:YES];
    [scanner setStopOnFirst:YES];
}

- (IBAction)presentModal:(id)sender {
    [self presentViewController:scanner animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
