//
//  StyleKit.m
//  GraphView
//
//  Created by Javier Loucim on 22/1/15.
//  Copyright (c) 2015 FuzeIdea. All rights reserved.
//
//  Generated by PaintCode (www.paintcodeapp.com)
//

#import "StyleKit.h"


@implementation StyleKit

#pragma mark Initialization

+ (void)initialize
{
}

#pragma mark Drawing Methods

+ (void)drawBubbleWithStrokeColor: (UIColor*)strokeColor fillColor: (UIColor*)fillColor fontColor: (UIColor*)fontColor label: (NSString*)label fontSize: (CGFloat)fontSize strokeWidth: (CGFloat)strokeWidth size: (CGSize)size percentage: (CGFloat)percentage;
{
    //// Color Declarations
    CGFloat strokeColorHSBA[4];
    [strokeColor getHue: &strokeColorHSBA[0] saturation: &strokeColorHSBA[1] brightness: &strokeColorHSBA[2] alpha: &strokeColorHSBA[3]];

    UIColor* progressBarColor = [UIColor colorWithHue: strokeColorHSBA[0] saturation: 0.2 brightness: strokeColorHSBA[2] alpha: strokeColorHSBA[3]];

    //// Variable Declarations
    CGPoint initialCoordinates = CGPointMake(5, 5);
    CGPoint textCoordinate = CGPointMake(initialCoordinates.x, initialCoordinates.y);
    CGSize circleSize = CGSizeMake(size.width - initialCoordinates.x * 2, size.height - initialCoordinates.y * 2);
    CGSize textSize = CGSizeMake(circleSize.width, circleSize.height);
    CGFloat startingAngle = 90;
    CGFloat endingAngle = percentage == 1 ? -270 : (1 - percentage) * 360 + startingAngle;
    CGFloat progressBarRatio = 0.72;
    CGSize progressBarMaskCircleSize = CGSizeMake(circleSize.width * progressBarRatio, circleSize.height * progressBarRatio);
    CGPoint maskCoordinates = CGPointMake(initialCoordinates.x + (circleSize.width - progressBarMaskCircleSize.width) / 2.0, initialCoordinates.y + (circleSize.height - progressBarMaskCircleSize.height) / 2.0);

    //// Contour Drawing
    UIBezierPath* contourPath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(initialCoordinates.x, initialCoordinates.y, circleSize.width, circleSize.height)];
    [fillColor setFill];
    [contourPath fill];
    [strokeColor setStroke];
    contourPath.lineWidth = strokeWidth;
    [contourPath stroke];


    //// PercentageCircle Drawing
    CGRect percentageCircleRect = CGRectMake(textCoordinate.x, textCoordinate.y, circleSize.width, circleSize.height);
    UIBezierPath* percentageCirclePath = UIBezierPath.bezierPath;
    [percentageCirclePath addArcWithCenter: CGPointMake(CGRectGetMidX(percentageCircleRect), CGRectGetMidY(percentageCircleRect)) radius: CGRectGetWidth(percentageCircleRect) / 2 startAngle: -startingAngle * M_PI/180 endAngle: -endingAngle * M_PI/180 clockwise: YES];
    [percentageCirclePath addLineToPoint: CGPointMake(CGRectGetMidX(percentageCircleRect), CGRectGetMidY(percentageCircleRect))];
    [percentageCirclePath closePath];

    [progressBarColor setFill];
    [percentageCirclePath fill];


    //// MaskCircle Drawing
    UIBezierPath* maskCirclePath = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(maskCoordinates.x, maskCoordinates.y, progressBarMaskCircleSize.width, progressBarMaskCircleSize.height)];
    [fillColor setFill];
    [maskCirclePath fill];


    //// CircleText Drawing
    CGRect circleTextRect = CGRectMake(textCoordinate.x, textCoordinate.y, textSize.width, textSize.height);
    NSMutableParagraphStyle* circleTextStyle = NSMutableParagraphStyle.defaultParagraphStyle.mutableCopy;
    circleTextStyle.alignment = NSTextAlignmentCenter;

    NSDictionary* circleTextFontAttributes = @{NSFontAttributeName: [UIFont fontWithName: @"HelveticaNeue-Medium" size: fontSize], NSForegroundColorAttributeName: fontColor, NSParagraphStyleAttributeName: circleTextStyle};

    [label drawInRect: CGRectOffset(circleTextRect, 0, (CGRectGetHeight(circleTextRect) - [label boundingRectWithSize: circleTextRect.size options: NSStringDrawingUsesLineFragmentOrigin attributes: circleTextFontAttributes context: nil].size.height) / 2) withAttributes: circleTextFontAttributes];
}

@end
