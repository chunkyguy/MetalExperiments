//
// Created by Sidharth Juyal on 20/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#import "GameViewController.h"
#import "Renderer.h"
#import "WLRenderView.h"

@interface GameViewController ()
{
  WLRenderView *_view;
  CADisplayLink *_displayLink;
}
@end

@implementation GameViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _view = (WLRenderView *)self.view;
  [_view setUp];
  
  _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick)];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)viewDidDisappear:(BOOL)animated
{
  [super viewDidDisappear:animated];
  [_displayLink invalidate];
}

- (void)tick
{
  [_view redrawWithDeltaTime:_displayLink.duration];
}

@end
