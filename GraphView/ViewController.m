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
#import "GraphViewProtocols.h"
#import "BubbleView.h"


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
@property(nonatomic, strong) NSArray *outConnections;
@property(nonatomic, weak) GraphNodeView *view;

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

-(NSString *)description {
    NSMutableString *s = [NSMutableString stringWithFormat: @"Node %@ (%f) - [%@]", self.key, self.size, [self.outConnections componentsJoinedByString:@","]];
    return s;
}

@end

@interface ViewController () <GraphViewDelegate>
@property(nonatomic, strong) GraphView *graphView;
@property(nonatomic, strong) id<Graph> graph;
@end

@implementation ViewController

NSDictionary *jsonGraph;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat nodeSideLength = 88.0f;
    
    GraphView *gv = [[GraphView alloc] init];
    gv.backgroundColor = [UIColor whiteColor];
    gv.connectionColor = [UIColor redColor];
    gv.largestNodeSize = CGSizeMake(nodeSideLength, nodeSideLength);
    
    _graphView = gv;
    UIView *subview = gv;
    
#define USE_SCROLLVIEW 0


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
    
    
    
    NSString *file = [[NSBundle mainBundle] pathForResource:@"graph" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:file];
    
    jsonGraph = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
}

-(id<Graph>) createJsonGraph {
    
    TestGraph *jsonMorseGraph = [[TestGraph alloc] init];
    
    NSArray *nodes = [jsonGraph objectForKey:@"nodes"];
    NSMutableDictionary *nodeIndex = [NSMutableDictionary dictionary];
    
    for (int x=0; x < [nodes count];x++) {
        
        NSDictionary *currentNode = nodes[x];
        TestNode *node = [TestNode nodeWithKey:[currentNode objectForKey:kNodeKey]];

        if ([currentNode objectForKey:kConnectionsKey]) {
            NSMutableArray *outConnections = [[NSMutableArray alloc] init];
            NSArray *connections = [currentNode objectForKey:kConnectionsKey];
            
            for (int z=0; z<[connections count];z++) {
                [outConnections addObject:[connections[z] objectForKey:kNodeKey]];
            }
            node.outConnections = outConnections;
        } else {
            node.outConnections = @[];
        }
        node.size = [[nodes[x] objectForKey:kSizeKey] floatValue];
        
        nodeIndex[node.key] = node;
        NSLog(@"%@",[nodes[x] objectForKey:@"name"]);
    }
    
    jsonMorseGraph.nodeIndex = nodeIndex;
    
    return jsonMorseGraph;
}

-(void)viewDidAppear:(BOOL)animated {

    _graph = [self createJsonGraph];
//    _graph = [self morseGraph];
//    _graph = [self createGraph];
    _graphView.delegate = self;
    [_graphView setGraph:_graph];
    [_graphView layoutIfNeeded];
}


static NSString * const kNodeKey = @"NodeKey";
static NSString * const kSizeKey = @"SizeKey";
static NSString * const kConnectionsKey = @"ConnectionsKey";

-(id<Graph>) morseGraph {
    NSMutableDictionary *index = [NSMutableDictionary dictionary];
    for (int i=0; i < 27; ++i) {
        char key = 'A' + i;
        NSString *keyString = [NSString stringWithFormat:@"%c", key];
        TestNode *node = [TestNode nodeWithKey:keyString];
        index[keyString] = node;
    }
    
    TestNode *root = [TestNode nodeWithKey:@"ROOT"];
    root.size = 50;
    
    NSArray *usedNodes = @[
                           @{kNodeKey: @"A", kConnectionsKey: @[@"W", @"R"]},
                           @{kNodeKey: @"B", kConnectionsKey: @[]},
                           @{kNodeKey: @"C", kConnectionsKey: @[]},
                           @{kNodeKey: @"D", kConnectionsKey: @[@"X", @"B"]},
                           @{kNodeKey: @"E", kConnectionsKey: @[@"A", @"I"]},
                           @{kNodeKey: @"F", kConnectionsKey: @[]},
                           @{kNodeKey: @"G", kConnectionsKey: @[@"Q", @"Z"]},
                           @{kNodeKey: @"H", kConnectionsKey: @[]},
                           @{kNodeKey: @"I", kConnectionsKey: @[@"U", @"S"]},
                           @{kNodeKey: @"J", kConnectionsKey: @[]},
                           @{kNodeKey: @"K", kConnectionsKey: @[@"Y", @"C"]},
                           @{kNodeKey: @"L", kConnectionsKey: @[]},
                           @{kNodeKey: @"M", kConnectionsKey: @[@"O", @"G"]},
                           @{kNodeKey: @"N", kConnectionsKey: @[@"K", @"D"]},
                           @{kNodeKey: @"O", kConnectionsKey: @[]},
                           @{kNodeKey: @"P", kConnectionsKey: @[]},
                           @{kNodeKey: @"Q", kConnectionsKey: @[]},
                           @{kNodeKey: @"R", kConnectionsKey: @[@"L"]},
                           @{kNodeKey: @"S", kConnectionsKey: @[@"V", @"H"]},
                           @{kNodeKey: @"T", kConnectionsKey: @[@"M", @"N"]},
                           @{kNodeKey: @"U", kConnectionsKey: @[@"F"]},
                           @{kNodeKey: @"V", kConnectionsKey: @[]},
                           @{kNodeKey: @"W", kConnectionsKey: @[@"J", @"P"]},
                           @{kNodeKey: @"X", kConnectionsKey: @[]},
                           @{kNodeKey: @"Y", kConnectionsKey: @[]},
                           @{kNodeKey: @"Z", kConnectionsKey: @[]},
                           ];
    
    
    
    TestGraph *graph = [[TestGraph alloc] init];
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    d[@"ROOT"] = root;
    
    [usedNodes enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        TestNode *node = index[obj[kNodeKey]];
        node.outConnections = obj[kConnectionsKey];
        node.size = 35.0;
        d[node.key] = node;
    }];
    graph.nodeIndex = d;
    [root connectToNode:graph.nodeIndex[@"E"]];
    [root connectToNode:graph.nodeIndex[@"T"]];
    return graph;
    
    
}

-(id<Graph>) createGraph {
    
    NSMutableDictionary *index = [NSMutableDictionary dictionary];
    for (int i=0; i < 27; ++i) {
        char key = 'A' + i;
        NSString *keyString = [NSString stringWithFormat:@"%c", key];
        TestNode *node = [TestNode nodeWithKey:keyString];
        index[keyString] = node;
    }
    
    CGFloat stdSize = 240;
    CGFloat multi1 = 3;
    CGFloat multi2 = 0.5;
    
    
    NSArray *usedNodes = @[
                           @{kNodeKey: @"A", kSizeKey: @(stdSize), kConnectionsKey: @[@"B", @"C", @"D", @"N"]},
                           @{kNodeKey: @"B", kSizeKey: @(stdSize), kConnectionsKey: @[@"E", @"F", @"G"]},
                           @{kNodeKey: @"C", kSizeKey: @(stdSize), kConnectionsKey: @[@"H", @"I", @"J"]},
                           @{kNodeKey: @"D", kSizeKey: @(stdSize), kConnectionsKey: @[@"K", @"L", @"M"]},
                           @{kNodeKey: @"E", kSizeKey: @(stdSize * multi2), kConnectionsKey: @[]},
                           @{kNodeKey: @"F", kSizeKey: @(stdSize * multi2) , kConnectionsKey: @[]},
                           @{kNodeKey: @"G", kSizeKey: @(stdSize * multi2), kConnectionsKey: @[]},
                           @{kNodeKey: @"H", kSizeKey: @(stdSize * multi2), kConnectionsKey: @[]},
                           @{kNodeKey: @"I", kSizeKey: @(stdSize * multi2) , kConnectionsKey: @[]},
                           @{kNodeKey: @"J", kSizeKey: @(stdSize * multi2), kConnectionsKey: @[]},
                           @{kNodeKey: @"K", kSizeKey: @(stdSize * multi2), kConnectionsKey: @[]},
                           @{kNodeKey: @"L", kSizeKey: @(stdSize * multi2) , kConnectionsKey: @[]},
                           @{kNodeKey: @"M", kSizeKey: @(stdSize * multi2), kConnectionsKey: @[]},
                           @{kNodeKey: @"N", kSizeKey: @(stdSize * multi2), kConnectionsKey: @[]},
                           ];
    
    
    
    TestGraph *graph = [[TestGraph alloc] init];
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    [usedNodes enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL *stop) {
        TestNode *node = index[obj[kNodeKey]];
        node.size = [obj[kSizeKey] floatValue];
        node.outConnections = obj[kConnectionsKey];
        d[node.key] = node;
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
    return @"ROOT";
}

-(GraphNodeView *)graphView:(GraphView *)graphView viewForNode:(id<GraphNode>)node {
    //TODO: add GraphNodeView reuse
    
#define NICOS_WAY 0
    
#if NICOS_WAY
    BubbleNodeView *nodeView = [[BubbleNodeView alloc] init];
    nodeView.strokeColor = [UIColor blueColor];
    nodeView.fillColor = graphView.backgroundColor;
    nodeView.node = node;
#else
    BubbleView *nodeView = [[BubbleView alloc] init];
    
    
    nodeView.strokeColor = [UIColor darkGrayColor];
    nodeView.fillColor = [UIColor lightGrayColor];
    nodeView.fontColor = [UIColor blackColor];
    nodeView.strokeWidth = 3.0f;
    nodeView.labelText = node.key;
    nodeView.fontSize = 11.0f;
    
    nodeView.node = node;
#endif
    
    return nodeView;
}

-(void)graphView:(GraphView *)graphView didSelectNode:(id<GraphNode>)node {
    NSLog(@"tapped node %@", node.key);
}

@end
