//
//  BubbleView.h
//  BubbleChart
//
//  Created by Javi on 20/1/15.
//  Copyright (c) 2015 FuzeIdea. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphView.h"

@interface BubbleView : GraphNodeView


@property (strong, nonatomic) UIColor *strokeColor;
@property (strong, nonatomic) UIColor *fillColor;
@property (strong, nonatomic) UIColor *fontColor;
@property (strong, nonatomic) NSString *labelText;
@property (nonatomic) float fontSize;
@property (nonatomic) float strokeWidth;
@property (nonatomic) CGSize size;
@property (nonatomic) float percentage;

@end
