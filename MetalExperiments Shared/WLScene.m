//
// Created by Sidharth Juyal on 27/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
//

#import "WLScene.h"
#import "WLActor.h"
#import "WLCamera.h"
#import "WLOBJActor.h"
#import "WLPlane.h"

@interface WLScene () {
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
  WLOBJActor *actor = [[WLOBJActor alloc] initWithDevice:device
                                                   named:@"bs_ears.obj"
                                                position:simd_make_float3(0.0f)];
  [actor setSpeed:WLOBJActorRotationSpeedNone];
  actor.textureNames = @[ @"ogre_diffuse.png", @"ogre_normalmap.png" ];
  _actors = @[ actor ];
}

- (void)update:(float)dt event:(WLKeyEvent)event
{
  [_camera updateEvent:event];
  for (WLActor *actor in _actors) {
    [actor update:dt];
  }
}

- (void)render:(id<MTLRenderCommandEncoder>)command
{
  for (WLActor *actor in _actors) {
    [actor render:command camera:_camera];
  }
}

@end
