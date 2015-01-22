//
//  GraphView.m
//  GraphView
//
//  Created by Nicolas Ameghino on 1/19/15.
//  Copyright (c) 2015 Nicolas Ameghino. All rights reserved.
//

#import "GraphView.h"
#import "GraphViewProtocols.h"

CGRect CGRectMakeWithCenterAndSize(CGPoint center, CGSize size) {
    CGPoint origin = CGPointMake(center.x - size.width/2.0,
                                 center.y - size.height/2.0);
    return (CGRect){origin, size};
}

CGPoint CGPointFromCenterAngleRadius(CGPoint center, CGFloat angle, CGFloat radius) {
    
    CGFloat dx = cosf(angle) * radius;
    CGFloat dy = sinf(angle) * radius;
    
    return CGPointMake(center.x + dx, center.y + dy);
}

static NSInteger const kBaseTag = 1041;

@interface GraphNodeView ()
@end

@implementation GraphNodeView

-(instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end

@interface GraphView ()
@property(nonatomic, strong) id<Graph> graph;
@property(nonatomic, strong) NSMutableDictionary *nodeViews;
@property(nonatomic, strong) id<GraphNode> largestNode;
@end

@implementation GraphView

-(instancetype)init {
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        _largestNodeSize = CGSizeMake(100.0f, 100.0f);
        _connectionLineWidth = 3.0f;
        _connectionColor = [UIColor blueColor];
        _layoutSizeType = kGraphLayoutNodeSizeRelative;
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
        nodeView.graphView = self;
        nodeView.tag = kBaseTag + n;
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
        [nodeView addGestureRecognizer:tgr];
        [self addSubview:nodeView];
        
        
        _nodeViews[node.key] = nodeView;
        node.view = nodeView;
        
        if (_largestNode) {
            _largestNode = node.size > _largestNode.size ? node : _largestNode;
        } else {
            _largestNode = node;
        }
    }
}

-(void)drawRect:(CGRect)rect {
    [self layoutIfNeeded];
    NSLog(@"draw rect");
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, self.backgroundColor.CGColor);
    CGContextFillRect(ctx, rect);
    [self drawConnections];
}

-(void)layoutSubviews {
    if ([self.delegate numberOfNodesInGraphView:self] == 0) {
        return;
    }
    NSString *rootKey = [self.delegate keyForFirstNodeInGraphView:self];
    id<GraphNode> first = [_graph nodeForKey:rootKey];
    if (self.layoutManager) {
        [self layoutUsingLayoutManager:first];
    } else {
        [self layoutNode:first atPoint:self.center toAngle:0 covering:2.0f * M_PI];
    }
    [self setNeedsDisplay];
}

-(void) layoutUsingLayoutManager:(id<GraphNode>) root {
    for (id<GraphNode> node in self.graph.nodes) {
        node.view.frame = [self.layoutManager graphView:self rectForNode:node];
    }
}

-(void) layoutNode:(id<GraphNode>) node
           atPoint:(CGPoint) point toAngle: (CGFloat) toAngle
          covering:(CGFloat) coverageAngle {
    GraphNodeView *nodeView = _nodeViews[node.key];
    NSAssert(nodeView, @"target node view not found (?)");
    CGPoint nodeCenter = point;
    CGFloat sizeRatio = node.size / _largestNode.size;
    
    CGSize nodeViewSize = CGSizeZero;
    if (self.layoutSizeType == kGraphLayoutNodeSizeRelative) {
        nodeViewSize = CGSizeMake(_largestNodeSize.width * sizeRatio,
                                  _largestNodeSize.height * sizeRatio);
    } else {
        nodeViewSize = CGSizeMake(node.size, node.size);
    }
    
    nodeView.frame = CGRectMakeWithCenterAndSize(nodeCenter, nodeViewSize);
    
    
    if (node.outDegree == 0) { return; }
    CGFloat distance = 50;
    CGFloat anglePerNode = coverageAngle / node.outDegree;
    CGFloat neighborIndex = -coverageAngle / 2.0f;
    CGFloat neighborIndexDelta = 1;
    
    for (NSString *neighborKey in node.outConnections) {
        id<GraphNode> neighbor = [self.graph nodeForKey:neighborKey];
        CGFloat angle = toAngle + (neighborIndex * anglePerNode);
        NSLog(@"\t%@ -> %.05f", neighborKey, angle);
        CGPoint targetPoint = CGPointFromCenterAngleRadius(nodeCenter,
                                                           angle,
                                                           distance + MAX(nodeViewSize.width, nodeViewSize.height));
        [self layoutNode:neighbor
                 atPoint:targetPoint
                 toAngle:angle
                covering:anglePerNode];
        neighborIndex += neighborIndexDelta;
    }
}

-(void) drawConnections {
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(ctx, self.connectionColor.CGColor);
    CGContextSetLineWidth(ctx, self.connectionLineWidth);
    NSInteger nodeCount = [self.delegate numberOfNodesInGraphView:self];
    for (NSInteger n = 0; n < nodeCount; ++n) {
        id<GraphNode> node = [self.graph nodeAtIndex:n];
        CGPoint source = [_nodeViews[node.key] center];
        for (NSString *nk in node.outConnections) {
            CGPoint target = [_nodeViews[nk] center];
            CGContextSaveGState(ctx);
            CGContextMoveToPoint(ctx, source.x, source.y);
            CGContextAddLineToPoint(ctx, target.x, target.y);
            CGContextStrokePath(ctx);
            CGContextRestoreGState(ctx);
        }
    }
}

//TODO: work this out without gesture recognizers and measure
-(void) tapHandler:(UITapGestureRecognizer *)tgr {
    GraphNodeView *nodeView = (GraphNodeView *)tgr.view;
    if ([self.delegate respondsToSelector:@selector(graphView:didSelectNode:)]) {
        [self.delegate graphView:self didSelectNode:nodeView.node];
    }
}
@end