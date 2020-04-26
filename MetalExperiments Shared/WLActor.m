//
// Created by Sidharth Juyal on 26/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#import "WLActor.h"
#import "WLMesh.h"
#import "WLMath.h"

@interface WLActor ()
{
  WLMesh *_mesh;
  matrix_float4x4 _mat;
  float _rotFactor;
}
@end

@implementation WLActor
+ (instancetype)actorWithMesh:(WLMesh *)mesh
{
  return [[self alloc] initWithMesh:mesh];
}

- (instancetype)initWithMesh:(WLMesh *)mesh
{
  self = [super init];
  if (self) {
    _mesh = mesh;
    _mat = matrix_identity_float4x4;
    _rotFactor = 0.0;
  }
  return self;
}

- (void)update:(float)dt
{
  _rotFactor += (dt * 0.25f );
  if (_rotFactor > 1.0f) {
    _rotFactor = 0.0f;
  }

  vector_float3 axis = {0, 1, 0};
  _mat = matrix4x4_rotation(M_PI * 2 * _rotFactor, axis);
}

- (matrix_float4x4)mat
{
  return _mat;
}

- (WLMesh *)mesh
{
  return _mesh;
}
@end
