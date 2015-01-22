//
//  GraphView.h
//  GraphView
//
//  Created by Nicolas Ameghino on 1/19/15.
//  Copyright (c) 2015 Nicolas Ameghino. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GraphNodeView;
@protocol GraphNode <NSObject>
@property(nonatomic, strong, readonly) NSString *key;
@property(nonatomic, assign, readonly) NSInteger outDegree;
@property(nonatomic, assign, readonly) CGFloat size;
@property(nonatomic, strong, readonly) NSArray *outConnections;
@property(nonatomic, weak) GraphNodeView *view;
@end

@protocol Graph <NSObject>
@property(nonatomic, strong, readonly) NSArray *nodes;
-(id<GraphNode>) nodeAtIndex:(NSInteger) index;
-(id<GraphNode>) nodeForKey:(NSString *) key;
@end

@class GraphView;
@protocol GraphNode;
@interface GraphNodeView : UIView
@property(nonatomic, strong) id<GraphNode> node;
@property(nonatomic, weak) GraphView *graphView;
@end

@protocol Graph, GraphNode, GraphViewDelegate, GraphViewLayout;
@interface GraphView : UIView
@property(nonatomic, weak) id<GraphViewDelegate> delegate;
@property(nonatomic, assign) CGSize largestNodeSize;
@property(nonatomic, strong) UIColor *connectionColor;
@property(nonatomic, assign) CGFloat connectionLineWidth;
-(void) setGraph:(id<Graph>) graph;
@end
