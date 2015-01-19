//
//  GraphView.m
//  GraphView
//
//  Created by Nicolas Ameghino on 1/19/15.
//  Copyright (c) 2015 Nicolas Ameghino. All rights reserved.
//

#import "GraphView.h"

static NSInteger const kBaseTag = 1041;

@interface GraphView ()
@property(nonatomic, strong) id<Graph> graph;
@property(nonatomic, strong) NSMutableDictionary *nodeViews;
@end

@implementation GraphView

-(void)setGraph:(id<Graph>)graph {
    _graph = graph;
    _nodeViews = [NSMutableDictionary dictionary];
    [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj removeFromSuperview];
    }];
    NSInteger nodeCount = [self.delegate numberOfNodesInGraphView:self];
    for (NSInteger n = 0; n < nodeCount; ++n) {
        id<GraphNode> node = [self.graph nodeAtIndex:n];
        GraphNodeView *nodeView = [self.delegate graphView:self viewForNode:node];
        nodeView.tag = kBaseTag + n;
        [self addSubview:nodeView];
        _nodeViews[node.key] = nodeView;
    }
}

-(void)layoutSubviews {
    id<GraphNode> first = _nodeViews[[self.delegate keyForFirstNodeInGraphView:self]];
    NSMutableArray *queue = [NSMutableArray array];
    NSMutableArray *done = [NSMutableArray array];
    [queue addObject:first];
    
    
    while([queue count] != 0) {
        id<GraphNode> node = [queue firstObject];
        [queue removeObject:node];
        if ([done containsObject:node]) { continue; }
        [done addObject:node];
        
        
    }
}

@end
