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


- (id) init {
//    self = [super init];
    
    strokeColor = [UIColor darkGrayColor];
    strokeWidth = 3.0f;
    fillColor = [UIColor lightGrayColor];
    fontColor = [UIColor blackColor];
    labelText = [[NSString alloc] init];
    fontSize = 11.0f;
    size = CGSizeMake(120.0f, 120.0f);
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [StyleKit drawBubbleWithStrokeColor:strokeColor fillColor:fillColor fontColor:fontColor label:labelText fontSize:fontSize strokeWidth:strokeWidth size: size];
}


@end
