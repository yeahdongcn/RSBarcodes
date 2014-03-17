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
        __weak typeof(self) weakSelf = self;
        self.barcodesHandler = ^(NSArray *barcodeObjects) {
            if (barcodeObjects.count > 0) {
                NSMutableString *text = [[NSMutableString alloc] init];
                [barcodeObjects enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [text appendString:[NSString stringWithFormat:@"%@: %@", [(AVMetadataObject *)obj type], [obj stringValue]]];
                    if (idx != (barcodeObjects.count - 1)) {
                        [text appendString:@"\n"];
                    }
                }];
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.codeLabel.numberOfLines = [barcodeObjects count];
                    weakSelf.codeLabel.text = text;
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    weakSelf.codeLabel.text = @"";
                });
            }
        };
        
        self.tapGestureHandler = ^(CGPoint tapPoint) {
        };
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.codeView.code = [CodeGen genCodeWithContents:@"09312345678907" machineReadableCodeObjectType:RSMetadataObjectTypeITF14Code];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.view bringSubviewToFront:self.codeView];
    
    [self.view bringSubviewToFront:self.codeLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
