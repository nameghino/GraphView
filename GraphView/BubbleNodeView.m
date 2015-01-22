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
    
#define USE_NICO_WAY 0
    
#if USE_NICO_WAY
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
    
#else
    UIColor *strokeColor = self.strokeColor;
    UIColor *fillColor = self.fillColor;
    UIColor *fontColor = [UIColor blackColor];
    NSString *label = @"ID?";
    CGFloat fontSize = 11.0f;
    CGFloat strokeWidth = 3.0f;
    CGSize size = self.frame.size;
    
    //// Variable Declarations
    CGSize textSize = CGSizeMake(size.width * 0.75, size.height * 0.75);
    CGPoint initialCoordinates = CGPointMake(2, 2);
    CGPoint textCoordinate = CGPointMake(size.width * 0.125 + initialCoordinates.x, size.height * 0.125 + initialCoordinates.y);
    
    //// Circle Drawing
    UIBezierPath* circlePath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(initialCoordinates.x, initialCoordinates.y, size.width-4, size.height-4)];
    [fillColor setFill];
    [circlePath fill];
    [strokeColor setStroke];
    circlePath.lineWidth = strokeWidth;
    [circlePath stroke];
    
    
    //// CircleText Drawing
    CGRect circleTextRect = CGRectMake(textCoordinate.x, textCoordinate.y, textSize.width, textSize.height);
    NSMutableParagraphStyle* circleTextStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    circleTextStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary* circleTextFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"Helvetica" size: fontSize], NSForegroundColorAttributeName: fontColor, NSParagraphStyleAttributeName: circleTextStyle};
    
    [label drawInRect: CGRectOffset(circleTextRect, 0, (CGRectGetHeight(circleTextRect) - [label boundingRectWithSize: circleTextRect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: circleTextFontAttributes context: nil].size.height) / 2) withAttributes: circleTextFontAttributes];
    
#endif

}

@end
