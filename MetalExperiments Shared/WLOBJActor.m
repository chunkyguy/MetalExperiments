//
// Created by Sidharth Juyal on 27/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#import "WLOBJActor.h"
#import "WLMesh.h"
#import "WLMath.h"
#import "WLResourceMesh.h"
#import "WLUtils.h"

@interface WLOBJActor ()
{
  WLMesh *_mesh;
  simd_float3 _position;
  matrix_float4x4 _mat;
  float _rotFactor;
  float _rotSpeed;
}
@end

@implementation WLOBJActor

- (instancetype)initWithDevice:(id<MTLDevice>)device
                         named:(NSString *)name
                      position:(simd_float3)position;
{
  self = [super initWithDevice:device];
  if (self) {
    _mesh = [[WLResourceMesh alloc] initWithDevice:device
                                          resource:[WLUtils resourceNamed:name]];
    _mat = matrix_identity_float4x4;
    _position = position;
    _rotFactor = 0.0;
    [self setSpeed:WLOBJActorRotationSpeedSlow];
  }
  return self;
}

- (void)setSpeed:(WLOBJActorRotationSpeed)speed
{
  switch (speed) {
    case WLOBJActorRotationSpeedNone: _rotSpeed = 0.0f; break;
    case WLOBJActorRotationSpeedSlow: _rotSpeed = 0.03f; break;
    case WLOBJActorRotationSpeedFast: _rotSpeed = 0.25f; break;
  }
}

- (void)update:(float)dt
{
  [super update:dt];
  _rotFactor += (dt * _rotSpeed );
  if (_rotFactor > 1.0f) {
    _rotFactor = 1.0 - _rotFactor;
  }

  vector_float3 axis = { 0, 1, 0 };
  simd_float4x4 rMat  = wl_rotation(M_PI * 2 * _rotFactor, axis);
  simd_float4x4 tMat = wl_translation_float3(_position);
  _mat = matrix_multiply(tMat, rMat);
}

- (matrix_float4x4)modelMatrix
{
  return _mat;
}

- (WLMesh *)mesh
{
  return _mesh;
}

@end
