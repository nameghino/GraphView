//
//  BubbleView.m
//  BubbleChart
//
//  Created by Javi on 20/1/15.
//  Copyright (c) 2015 FuzeIdea. All rights reserved.
//

#import "BubbleView.h"
#import "StyleKit.h"

@implementation BubbleView

@synthesize strokeWidth;
@synthesize strokeColor;
@synthesize fillColor;
@synthesize fontSize;
@synthesize fontColor;
@synthesize size;
@synthesize labelText;
@synthesize percentage;


- (id) init {
    self = [super init];
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code

    [StyleKit drawBubbleWithStrokeColor:strokeColor fillColor:fillColor fontColor:fontColor label:labelText fontSize:fontSize strokeWidth:strokeWidth size: CGSizeMake(self.frame.size.width, self.frame.size.height) percentage:percentage];
}


@end
