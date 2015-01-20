//
//  BubbleView.h
//  BubbleChart
//
//  Created by Javi on 20/1/15.
//  Copyright (c) 2015 FuzeIdea. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BubbleView : UIView
//[UIColor darkGrayColor] fillColor:[UIColor lightGrayColor] fontColor:[UIColor blackColor] label:@"Hello World" fontSize:18.0f strokeWidth:3.0f
//size: CGSizeMake(180.0f, 180.0f)];
//}

@property (strong, nonatomic) UIColor *strokeColor;
@property (strong, nonatomic) UIColor *fillColor;
@property (strong, nonatomic) UIColor *fontColor;
@property (strong, nonatomic) NSString *labelText;
@property (nonatomic) float fontSize;
@property (nonatomic) float strokeWidth;
@property (nonatomic) CGSize size;

@end
