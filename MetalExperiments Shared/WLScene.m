//
// Created by Sidharth Juyal on 27/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#import "WLScene.h"
#import "WLActor.h"
#import "WLCamera.h"
#import "WLTeapot.h"
#import "WLPlane.h"

@interface WLScene ()
{
  NSArray *_actors;
  WLCamera *_camera;
}
@end

@implementation WLScene
- (instancetype)init
{
  self = [super init];
  if (self) {
    _actors = [NSArray array];
    _camera = [WLCamera camera];
  }
  return self;
}

- (void)setUp:(id<MTLDevice>)device
{
  WLPlane *floor = [[WLPlane alloc] initWithDevice:device
                        direction:WLPlaneDirectionBottom];
  floor.textureNames = @[@"brick1.jpg"];

  WLTeapot *teapot = [[WLTeapot alloc] initWithDevice:device
                                             position:(simd_float3){ 0.0f, 0.0f, 0.0f }];
  teapot.textureNames = @[@"cement.jpg", @"moss.png"];
  _actors = @[floor, teapot];
}

- (void)update:(float)dt event:(WLKeyEvent)event
{
  [_camera updateEvent:event];
  for (WLActor *actor in _actors) {
    [actor update:dt];
  }
}

- (WLCamera *)camera
{
  return _camera;
}

- (NSArray *)actors
{
  return [_actors copy];
}
@end
