//
//  GraphView.m
//  GraphView
//
//  Created by Nicolas Ameghino on 1/19/15.
//  Copyright (c) 2015 Nicolas Ameghino. All rights reserved.
//

#import "GraphView.h"

CGRect CGRectMakeWithCenterAndSize(CGPoint center, CGSize size) {
    CGPoint origin = CGPointMake(center.x - size.width/2.0,
                                 center.y - size.height/2.0);
    return (CGRect){origin, size};
}

CGPoint CGPointFromCenterAngleRadius(CGPoint center, CGFloat angle, CGFloat radius) {
    return CGPointZero;
}

static NSInteger const kBaseTag = 1041;

@interface GraphNodeView ()
@end

@implementation GraphNodeView
@end

@interface GraphView ()
@property(nonatomic, strong) id<Graph> graph;
@property(nonatomic, strong) NSMutableDictionary *nodeViews;
@property(nonatomic, strong) id<GraphNode> largestNode;
@property(nonatomic, assign) CGSize largestNodeSize;
@end

@implementation GraphView

-(instancetype)init {
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        _largestNodeSize = CGSizeMake(44.0f, 44.0f);
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _largestNodeSize = CGSizeMake(44.0f, 44.0f);
    }
    return self;
}

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
        _largestNode = (_largestNode && node.size > _largestNode.size) ? _largestNode : node;
    }
}

-(void)layoutSubviews {
    id<GraphNode> first = _nodeViews[[self.delegate keyForFirstNodeInGraphView:self]];
    [self layoutNode:first atPoint:self.center angle:M_PI * 2.0];
}

-(void) layoutNode:(id<GraphNode>) node atPoint:(CGPoint) point angle:(CGFloat) childrenAngle {
    NSLog(@"Laying out node %@", node.key);
    CGPoint nodeCenter = point;
    CGFloat angleDelta = childrenAngle / node.outDegree;
    CGFloat radius = node.size * 0.1;
    CGFloat sizeRatio = node.size / _largestNode.size;

    GraphNodeView *nodeView = _nodeViews[node.key];

    CGSize nodeViewSize = CGSizeMake(_largestNodeSize.width * sizeRatio,
                                     _largestNodeSize.height * sizeRatio);
    nodeView.frame = CGRectMakeWithCenterAndSize(nodeCenter, nodeViewSize);
    
    NSAssert(nodeView, @"target node view not found (?)");
    
    
    NSInteger neighborIndex = 0;
    for (NSString *neighborKey in node.outConnections) {
        id<GraphNode> neighbor = _nodeViews[neighborKey];
        
        CGPoint targetPoint = CGPointFromCenterAngleRadius(nodeCenter,
                                                           angleDelta * neighborIndex,
                                                           radius + MAX(nodeViewSize.width, nodeViewSize.height));
        
        [self layoutNode:neighbor atPoint:targetPoint angle:angleDelta];
        neighborIndex++;
    }
    
}

@end
