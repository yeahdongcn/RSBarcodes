//
//  RSCornersView.m
//  RSBarcodes
//
//  Created by R0CKSTAR on 12/19/13.
//  Copyright (c) 2013 P.D.Q. All rights reserved.
//

#import "RSCornersView.h"

@implementation RSCornersView

- (void)__init
{
    self.backgroundColor = [UIColor clearColor];
    self.strokeColor = [UIColor greenColor];
    self.strokeWidth = 2.0;
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

- (void)setCornersArray:(NSArray *)cornersArray
{
    if (cornersArray.count > 0) {
        NSMutableArray *outerArray = [[NSMutableArray alloc] initWithCapacity:cornersArray.count];
        for (NSArray *corners in cornersArray) {
            NSMutableArray *innerArray = [[NSMutableArray alloc] init];
            for (NSDictionary *corner in corners) {
                [innerArray addObject:[NSValue valueWithCGPoint:CGPointMake([[corner objectForKey:@"X"] floatValue], [[corner objectForKey:@"Y"] floatValue])]];
            }
            [outerArray addObject:[NSArray arrayWithArray:innerArray]];
        }
        
        _cornersArray = [NSArray arrayWithArray:outerArray];
    } else {
        _cornersArray = nil;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}

- (void)setBorderRectArray:(NSArray *)borderRectArray
{
    if (borderRectArray.count > 0) {
        NSMutableArray *outerArray = [[NSMutableArray alloc] initWithCapacity:borderRectArray.count];
        for (NSValue *borderRectValue in borderRectArray) {
            CGRect borderRect = [borderRectValue CGRectValue];
            if (!CGRectEqualToRect(borderRect, CGRectZero)) {
                NSMutableArray *innerArray = [[NSMutableArray alloc] initWithCapacity:4];
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
                    [innerArray addObject:[NSValue valueWithCGPoint:CGPointMake(corner.x, corner.y)]];
                }
                [outerArray addObject:innerArray];
            }
        }
        _borderRectArray = [NSArray arrayWithArray:outerArray];
    } else {
        _borderRectArray = nil;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setNeedsDisplay];
    });
}

- (void)drawRect:(CGRect)rect
{
    for (NSArray *corners in self.cornersArray) {
        [self __drawCorners:corners];
    }
    
    for (NSArray *borders in self.borderRectArray) {
        [self __drawCorners:borders];
    }
}

@end
