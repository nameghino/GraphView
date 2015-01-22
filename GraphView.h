//
//  GraphView.h
//  GraphView
//
//  Created by Nicolas Ameghino on 1/19/15.
//  Copyright (c) 2015 Nicolas Ameghino. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GraphViewProtocols.h"

typedef NS_ENUM(NSInteger, GraphLayoutNodeSizeType) {
    kGraphLayoutNodeSizeRelative = 0,
    kGraphLayoutNodeSizeAbsolute = 1
};

@class GraphView;
@protocol GraphNode;
@interface GraphNodeView : UIView
@property(nonatomic, strong) id<GraphNode> node;
@property(nonatomic, weak) GraphView *graphView;
@end

@protocol Graph, GraphNode, GraphViewDelegate, GraphViewLayout;
@interface GraphView : UIView
@property(nonatomic, weak) id<GraphViewDelegate> delegate;
@property(nonatomic, weak) id<GraphViewLayout> layoutManager;

@property(nonatomic, strong) UIColor *connectionColor;
@property(nonatomic, assign) CGFloat connectionLineWidth;

@property(nonatomic, assign) GraphLayoutNodeSizeType layoutSizeType;
@property(nonatomic, assign) CGSize largestNodeSize;

-(void) setGraph:(id<Graph>) graph;
@end
