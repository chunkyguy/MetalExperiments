//
// Created by Sidharth Juyal on 27/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#import "WLTeapot.h"
#import "WLMesh.h"
#import "WLMath.h"
#import "WLResourceMesh.h"

@interface WLTeapot ()
{
  WLMesh *_mesh;
  matrix_float4x4 _mat;
  float _rotFactor;
}
@end

@implementation WLTeapot

- (instancetype)initWithDevice:(id<MTLDevice>)device
{
  self = [super initWithDevice:device];
  if (self) {
    NSURL *path = [[NSBundle mainBundle] URLForResource:@"teapot" withExtension:@"obj"];
    _mesh = [[WLResourceMesh alloc] initWithDevice:device resource:path name:@"teapot"];
    _mat = matrix_identity_float4x4;
    _rotFactor = 0.0;
  }
  return self;
}

- (void)update:(float)dt
{
  _rotFactor += (dt * 0.25f );
  if (_rotFactor > 1.0f) {
    _rotFactor = 1.0 - _rotFactor;
  }

  vector_float3 axis = { 1, 1, 0 };
  _mat = wl_matrix4x4_rotation(M_PI * 2 * _rotFactor, axis);
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