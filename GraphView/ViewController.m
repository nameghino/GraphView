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

@interface ViewController () <GraphViewDelegate>
@property(nonatomic, strong) GraphView *graphView;
@property(nonatomic, strong) id<Graph> graph;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GraphView *gv = [[GraphView alloc] init];
    [self.view addSubview:gv];
    NSDictionary *views = NSDictionaryOfVariableBindings(gv);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[gv]|"
                                                                      options:NSLayoutFormatAlignAllCenterY
                                                                      metrics:nil
                                                                        views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[gv]|"
                                                                      options:NSLayoutFormatAlignAllCenterX
                                                                      metrics:nil
                                                                        views:views]];
    _graphView = gv;
}

-(void)viewDidAppear:(BOOL)animated {
    id<Graph> graph = [self createGraph];
    [_graphView setGraph:graph];
    [_graphView layoutIfNeeded];
}


-(id<Graph>) createGraph {
    return nil;
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
    GraphNodeView *nodeView = [[BubbleNodeView alloc] init];
    nodeView.node = node;
    return nodeView;
}

@end
