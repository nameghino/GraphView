//
//  BubbleNodeView.m
//  GraphView
//
//  Created by Nicolas Ameghino on 1/20/15.
//  Copyright (c) 2015 Nicolas Ameghino. All rights reserved.
//

#import "BubbleNodeView.h"

@implementation BubbleNodeView

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [UIColor clearColor].CGColor);
    CGContextSetStrokeColorWithColor(ctx, [UIColor redColor].CGColor);
    CGContextSetLineWidth(ctx, 2.0f);
    CGContextStrokeEllipseInRect(ctx, CGRectInset(rect, 4.0f, 4.0f));
    [self.node.key drawInRect:rect withAttributes:nil];
}

@end
