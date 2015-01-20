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
    
    UIFont *font = [UIFont boldSystemFontOfSize:14.0f];
    NSDictionary *attributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor blackColor]};
    
    CGSize labelSize = [self.node.key sizeWithAttributes:attributes];
    CGPoint labelOrigin = CGPointMake((rect.size.width - labelSize.width) /2.0f,
                                      (rect.size.height - labelSize.height) / 2.0f);
    
    CGRect labelRect = (CGRect){labelOrigin, labelSize};
    [self.node.key drawInRect:labelRect withAttributes:attributes];
}

@end
