//
//  RSCornersView.m
//  RSBarcodes
//
//  Created by R0CKSTAR on 12/19/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "RSCornersView.h"

@interface RSCornersView ()

@property (nonatomic, copy) NSArray *borderCorners;

@end

@implementation RSCornersView

- (void)__init
{
    self.backgroundColor = [UIColor clearColor];
    self.strokeColor = [UIColor greenColor];
    self.strokeWidth = 1.0;
}

- (void)__drawCorners:(NSArray *)corners
{
    if (!corners) {
        return;
    }
    
    if (corners.count <= 1) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    [[UIColor clearColor] setFill];
    [self.strokeColor setStroke];
    
    CGContextSetLineWidth(context, self.strokeWidth);
    
    NSValue *startPointValue = corners[0];
    CGPoint  startPoint      = [startPointValue CGPointValue];
    CGContextMoveToPoint(context, startPoint.x, startPoint.y);
    
    for(int i = 1; i <= corners.count; i++) {
        int index = i;
        if (index == corners.count) {
            index = 0;
        }
        NSValue *pointValue = corners[index];
        CGPoint  point      = [pointValue CGPointValue];
        CGContextAddLineToPoint(context, point.x,point.y);
    }
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextRestoreGState(context);
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

- (void)setCorners:(NSArray *)corners
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:corners.count];
    for (NSDictionary *corner in corners) {
        [array addObject:[NSValue valueWithCGPoint:CGPointMake([[corner objectForKey:@"X"] floatValue], [[corner objectForKey:@"Y"] floatValue])]];
    }
    _corners = [NSArray arrayWithArray:array];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}

- (void)setBorderRect:(CGRect)borderRect
{
    if (CGRectEqualToRect(borderRect, CGRectZero)) {
        self.borderCorners = nil;
    } else {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:4];
        for (int i = 0; i < 4; i++) {
            CGPoint corner = CGPointZero;
            if (i == 0) {
                corner = CGPointMake(borderRect.origin.x, borderRect.origin.y);
            } else if (i == 1) {
                corner = CGPointMake(borderRect.origin.x + borderRect.size.width, borderRect.origin.y);
            } else if (i == 2) {
                corner = CGPointMake(borderRect.origin.x + borderRect.size.width, borderRect.origin.y + borderRect.size.height);
            } else if (i == 3) {
                corner = CGPointMake(borderRect.origin.x, borderRect.origin.y + borderRect.size.height);
            }
            [array addObject:[NSValue valueWithCGPoint:CGPointMake(corner.x, corner.y)]];
        }
        self.borderCorners = [NSArray arrayWithArray:array];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setNeedsDisplay];
        });
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    [self __drawCorners:self.corners];
    
    [self __drawCorners:self.borderCorners];
}

@end
