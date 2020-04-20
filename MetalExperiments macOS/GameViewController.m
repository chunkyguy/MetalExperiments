//
// Created by Sidharth Juyal on 20/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#import "GameViewController.h"
#import "WLRenderView.h"

@implementation GameViewController
{
  WLRenderView *_view;
  
  Renderer *_renderer;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  _view = (WLRenderView *)self.view;
  [_view setUp];
  //
  //    _view.device = MTLCreateSystemDefaultDevice();
  //
  //    if(!_view.device)
  //    {
  //        NSLog(@"Metal is not supported on this device");
  //        self.view = [[NSView alloc] initWithFrame:self.view.frame];
  //        return;
  //    }
  //
  //    _renderer = [[Renderer alloc] initWithMetalKitView:_view];
  //
  //    [_renderer mtkView:_view drawableSizeWillChange:_view.bounds.size];
  //
  //    _view.delegate = _renderer;
  
  
}

- (void)viewDidAppear
{
  [super viewDidAppear];
  [_view redraw];
}

@end
