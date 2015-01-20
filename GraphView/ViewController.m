//
//  ViewController.m
//  GraphView
//
//  Created by Nicolas Ameghino on 1/19/15.
//  Copyright (c) 2015 Nicolas Ameghino. All rights reserved.
//

#import "ViewController.h"
#import "GraphView.h"
#import "BubbleNodeView.h"

@interface TestGraph : NSObject <Graph>
@property(nonatomic, strong) NSMutableDictionary *nodeIndex;
@property(nonatomic, strong) NSArray *sortedNodes;
@end

@implementation TestGraph
-(NSArray *)nodes {
    return _sortedNodes;
}

-(void)setNodeIndex:(NSMutableDictionary *)nodeIndex {
    _nodeIndex = nodeIndex;
    _sortedNodes = [_nodeIndex.allValues sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"key" ascending:YES]]];
}

-(id<GraphNode>)nodeAtIndex:(NSInteger)index {
    return _sortedNodes[index];
}

-(id<GraphNode>)nodeForKey:(NSString *)key {
    return _nodeIndex[key];
}
@end

@interface TestNode : NSObject <GraphNode>
@property(nonatomic, assign) CGFloat size;
@property(nonatomic, strong, readonly) NSString *key;
@property(nonatomic, strong, readonly) NSArray *outConnections;
@end

@implementation TestNode

+(instancetype)nodeWithKey:(NSString *) key {
    return [[self alloc] initWithKey:key];
}

-(instancetype)initWithKey:(NSString *)key; {
    self = [super init];
    if (self) {
        _size = 10.0f;
        _key = key;
        _outConnections = @[];
    }
    return self;
}

-(NSInteger)outDegree {
    return [self.outConnections count];
}

-(void) connectToNode:(TestNode *)target {
    _outConnections = [_outConnections arrayByAddingObject:target.key];
}

@end

@interface ViewController () <GraphViewDelegate>
@property(nonatomic, strong) GraphView *graphView;
@property(nonatomic, strong) id<Graph> graph;
@end

@implementation ViewController

#define USE_SCROLLVIEW 0

- (void)viewDidLoad {
    [super viewDidLoad];
    GraphView *gv = [[GraphView alloc] init];
    gv.backgroundColor = [UIColor whiteColor];
    gv.connectionColor = [UIColor redColor];
    
    _graphView = gv;
    UIView *subview = gv;
#if USE_SCROLLVIEW
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    subview = scrollView;
    [scrollView addSubview:gv];
    scrollView.contentSize = CGSizeMake(1000, 1000); //TODO: WTF?
#endif
    [self.view addSubview:subview];
#if USE_SCROLLVIEW
    gv.frame = scrollView.bounds;
#endif
    
    NSDictionary *views = NSDictionaryOfVariableBindings(subview);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[subview]|"
                                                                      options:NSLayoutFormatAlignAllCenterY
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[subview]|"
                                                                      options:NSLayoutFormatAlignAllCenterX
                                                                      metrics:nil
                                                                        views:views]];
    


    
    
}

-(void)viewDidAppear:(BOOL)animated {
    _graph = [self createGraph];
    _graphView.delegate = self;
    [_graphView setGraph:_graph];
    [_graphView layoutIfNeeded];
}


-(id<Graph>) createGraph {
    TestNode *aNode = [TestNode nodeWithKey:@"A"];
    TestNode *bNode = [TestNode nodeWithKey:@"B"];
    TestNode *cNode = [TestNode nodeWithKey:@"C"];
    TestNode *dNode = [TestNode nodeWithKey:@"D"];
    TestNode *eNode = [TestNode nodeWithKey:@"E"];
    TestNode *fNode = [TestNode nodeWithKey:@"F"];

    NSArray *nodeArray = @[aNode, bNode, cNode, dNode, eNode, fNode];
    
    aNode.size = 30.0f;
    cNode.size = 5.0f;
    eNode.size = 20.0f;
    fNode.size = 15.0f;
    
    
    [aNode connectToNode:bNode];
    [aNode connectToNode:cNode];
    [bNode connectToNode:dNode];
    [bNode connectToNode:eNode];
    [cNode connectToNode:fNode];
    
    TestGraph *graph = [[TestGraph alloc] init];
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [nodeArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        d[[obj key]] = obj;
    }];
    graph.nodeIndex = d;
    
    return graph;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - GraphViewDelegate
-(NSInteger)numberOfNodesInGraphView:(GraphView *)graphView {
    return [self.graph.nodes count];
}

-(NSString *)keyForFirstNodeInGraphView:(GraphView *)graphView {
    return @"A";
}

-(GraphNodeView *)graphView:(GraphView *)graphView viewForNode:(id<GraphNode>)node {
    //TODO: add GraphNodeView reuse
    BubbleNodeView *nodeView = [[BubbleNodeView alloc] init];
    nodeView.strokeColor = [UIColor blueColor];
    nodeView.fillColor = graphView.backgroundColor;
    nodeView.node = node;
    return nodeView;
}

@end
