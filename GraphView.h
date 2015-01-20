//
//  GraphView.h
//  GraphView
//
//  Created by Nicolas Ameghino on 1/19/15.
//  Copyright (c) 2015 Nicolas Ameghino. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GraphNode <NSObject>
@property(nonatomic, strong, readonly) NSString *key;
@property(nonatomic, assign, readonly) NSInteger outDegree;
@property(nonatomic, assign, readonly) CGFloat size;
@property(nonatomic, strong, readonly) NSArray *outConnections;
@end

@protocol Graph <NSObject>
@property(nonatomic, strong, readonly) NSArray *nodes;
-(id<GraphNode>) nodeAtIndex:(NSInteger) index;
-(id<GraphNode>) nodeForKey:(NSString *) key;
@end

@class GraphView;
@interface GraphNodeView : UIView
@property(nonatomic, strong) id<GraphNode> node;
@property(nonatomic, weak) GraphView *graphView;
@end

@class GraphView, GraphNodeView;
@protocol GraphViewDelegate <NSObject>
-(NSInteger) numberOfNodesInGraphView:(GraphView *)graphView;
-(NSString *) keyForFirstNodeInGraphView:(GraphView *)graphView;
-(GraphNodeView *) graphView:(GraphView *)graphView viewForNode:(id<GraphNode>) node;
@end

@protocol Graph, GraphNode;
@interface GraphView : UIView
@property(nonatomic, weak) id<GraphViewDelegate> delegate;
@property(nonatomic, strong) UIColor *connectionColor;
@property(nonatomic, assign) CGFloat connectionLineWidth;
-(void) setGraph:(id<Graph>) graph;
@end
