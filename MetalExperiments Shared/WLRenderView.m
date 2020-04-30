//
// Created by Sidharth Juyal on 20/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#import "WLRenderView.h"

#if TARGET_OS_IOS
#elif TARGET_OS_OSX
#import <Quartz/Quartz.h>
#endif

#import "WLRenderer.h"
#import "WLScene.h"

@interface WLRenderView ()
{
  CAMetalLayer *_metalLayer;
  WLRenderer *_renderer;
  WLScene *_scene;
}
@end

@implementation WLRenderView

#if TARGET_OS_IOS
+ (Class)layerClass
{
  return [CAMetalLayer class];
}

- (void)setUpLayer
{
  _metalLayer = (CAMetalLayer *)self.layer;
}
#elif TARGET_OS_OSX
- (void)setUpLayer
{
  [self setWantsLayer:YES];
  _metalLayer = [CAMetalLayer layer];
  [_metalLayer setFrame:self.frame];
  [self setLayer:_metalLayer];
}
#endif

- (void)setUp
{
  [self setUpLayer];

  _renderer = [[WLRenderer alloc] init];
  _scene = [[WLScene alloc] init];

  _metalLayer.device = _renderer.device;
  _metalLayer.pixelFormat = gConfig.pixelFormat;
  _metalLayer.drawableSize = self.frame.size;

  [_scene setUp:_renderer.device];
  [_renderer setUp];
  [_renderer resize:self.frame.size];
}

- (void)redrawWithDeltaTime:(float)dt;
{
  [_scene update:dt];
  id<CAMetalDrawable> drawable = [_metalLayer nextDrawable];
  [_renderer renderScene:_scene
                 texture:drawable.texture
                drawable:drawable];
}

@end
