//
// Created by Sidharth Juyal on 20/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#import "WLRenderView.h"
#import <Quartz/Quartz.h>
#import "WLRenderer.h"

@interface WLRenderView ()
{
  CAMetalLayer *_metalLayer;
  WLRenderer *_renderer;
}
@end

@implementation WLRenderView

- (void)setUp
{
  [self setWantsLayer:YES];
  _metalLayer = [CAMetalLayer layer];
  [_metalLayer setFrame:self.frame];
  [self setLayer:_metalLayer];

  _renderer = [[WLRenderer alloc] init];

  _metalLayer.device = _renderer.device;
  _metalLayer.pixelFormat = gConfig.pixelFormat;
  _metalLayer.drawableSize = self.frame.size;

  [_renderer resize:self.frame.size];
}


- (void)redrawWithDeltaTime:(float)dt;
{
  [_renderer update:dt];
  id<CAMetalDrawable> drawable = [_metalLayer nextDrawable];
  [_renderer renderWithTexture:drawable.texture drawable:drawable];
}


@end
