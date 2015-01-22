//
//  BubbleNodeView.m
//  GraphView
//
//  Created by Nicolas Ameghino on 1/20/15.
//  Copyright (c) 2015 Nicolas Ameghino. All rights reserved.
//

#import "BubbleNodeView.h"
#import "GraphViewProtocols.h"

@implementation BubbleNodeView

- (void)drawRect:(CGRect)rect {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, self.fillColor.CGColor);
    CGContextSetStrokeColorWithColor(ctx, self.strokeColor.CGColor);
    CGContextSetLineWidth(ctx, 2.0f);
    CGRect nodeRect = CGRectInset(rect, 4.0f, 4.0f);
    CGContextFillEllipseInRect(ctx, nodeRect);
    CGContextStrokeEllipseInRect(ctx, nodeRect);
    
    UIFont *font = [UIFont boldSystemFontOfSize:14.0f];
    NSDictionary *attributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: [UIColor blackColor]};
    
    CGSize labelSize = [self.node.key sizeWithAttributes:attributes];
    CGPoint labelOrigin = CGPointMake((rect.size.width - labelSize.width) /2.0f,
                                      (rect.size.height - labelSize.height) / 2.0f);
    
    CGRect labelRect = (CGRect){labelOrigin, labelSize};
    [self.node.key drawInRect:labelRect withAttributes:attributes];
}

@end
