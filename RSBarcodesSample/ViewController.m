//
//  ViewController.m
//  RSBarcodesSample
//
//  Created by R0CKSTAR on 12/24/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "ViewController.h"

#import "RSCodeView.h"

#import "RSCodeGen.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet RSCodeView *codeView;

@property (nonatomic, weak) IBOutlet UILabel *codeLabel;

@end

@implementation ViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        __weak typeof(self)weakSelf = self;
        self.handler = ^(NSArray *metadataObjects) {
            if (metadataObjects.count > 0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.codeLabel.text = [metadataObjects[0] stringValue];
                });
            }
        };
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    self.codeView.code = [CodeGen encode:@"Code 39" codeObjectType:AVMetadataObjectTypeCode39Code];
    [self.view bringSubviewToFront:self.codeView];
    
    [self.view bringSubviewToFront:self.codeLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
