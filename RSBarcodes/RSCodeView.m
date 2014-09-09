//
//  RSCodeView.m
//  RSBarcodes
//
//  Created by R0CKSTAR on 12/25/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "RSCodeView.h"

@implementation RSCodeView

- (void)__init {
    self.backgroundColor = [UIColor clearColor];
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor greenColor] CGColor];
}

- (id)init {
    self = [super init];
    if (self) {
        [self __init];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self __init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self __init];
    }
    return self;
}

- (void)setCode:(UIImage *)code {
    _code = code;
    
    dispatch_async(dispatch_get_main_queue(), ^{ [self setNeedsDisplay]; });
}

- (void)drawRect:(CGRect)rect {
    if (!_code) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    CGContextDrawImage(context, self.bounds, [self.code CGImage]);
    
    CGContextRestoreGState(context);
}

@end
