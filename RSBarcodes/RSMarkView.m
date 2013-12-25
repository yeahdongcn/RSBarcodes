//
//  RSMarkView.m
//  RSBarcodes
//
//  Created by R0CKSTAR on 12/25/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "RSMarkView.h"

@implementation RSMarkView

- (void)__init
{
    self.backgroundColor = [UIColor clearColor];
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = [[UIColor whiteColor] CGColor];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self __init];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self __init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self __init];
    }
    return self;
}

- (void)setMark:(UIImage *)mark
{
    _mark = mark;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}

- (void)drawRect:(CGRect)rect
{
    if (!_mark) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);

    CGContextDrawImage(context, rect, [self.mark CGImage]);
    
    CGContextRestoreGState(context);
}

@end
