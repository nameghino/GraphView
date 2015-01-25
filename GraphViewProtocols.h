//
//  GraphViewProtocols.h
//  GraphView
//
//  Created by Nicolas Ameghino on 1/22/15.
//  Copyright (c) 2015 Nicolas Ameghino. All rights reserved.
//

#import <Foundation/Foundation.h>

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

@class GraphView, GraphNodeView;
@protocol GraphViewDelegate <NSObject>
@required
-(NSInteger) numberOfNodesInGraphView:(GraphView *)graphView;
-(NSString *) keyForFirstNodeInGraphView:(GraphView *)graphView;
-(GraphNodeView *) graphView:(GraphView *)graphView viewForNode:(id<GraphNode>) node;
@optional
-(void) graphView:(GraphView *)graphView didSelectNode:(id<GraphNode>) node;
@end


@class GraphView;
@protocol GraphNode;
@protocol GraphViewLayout <NSObject>
@required
-(CGRect) graphView: (GraphView *) graphView rectForNode:(id<GraphNode>) node;
@end