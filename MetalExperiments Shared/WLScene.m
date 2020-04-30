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
  NSMutableArray *_actors;
  WLCamera *_camera;
}
@end

@implementation WLScene
- (instancetype)init
{
  self = [super init];
  if (self) {
    _actors = [NSMutableArray array];
    _camera = [WLCamera camera];
  }
  return self;
}

- (void)setUp:(id<MTLDevice>)device
{
  [_actors addObject:[[WLPlane alloc] initWithDevice:device]];
  [_actors addObject:[[WLTeapot alloc] initWithDevice:device]];
}

- (void)update:(float)dt
{
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