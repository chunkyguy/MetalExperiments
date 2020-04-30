//
// Created by Sidharth Juyal on 28/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#import "WLPlane.h"
#import "WLMath.h"
#import "WLPlaneMesh.h"

@interface WLPlane ()
{
  WLMesh *_mesh;
  matrix_float4x4 _mat;
}
@end

@implementation WLPlane

- (instancetype)initWithDevice:(id<MTLDevice>)device
{
  self = [super initWithDevice:device];
  if (self) {
    _mesh = [[WLPlaneMesh alloc] initWithDevice:device];
    _mat = matrix_identity_float4x4;
  }
  return self;
}

- (void)update:(float)dt
{
  vector_float3 axis = { 1, 0, 0 };
  matrix_float4x4 sMat = wl_matrix4x4_scale(7, 4, 1);
  matrix_float4x4 rMat = wl_matrix4x4_rotation(-M_PI * 0.4, axis);
  matrix_float4x4 tMat = wl_matrix4x4_translation(0, -5, -12);

  _mat = matrix_multiply(tMat, matrix_multiply(rMat, sMat));
}

- (matrix_float4x4)modelMatrix
{
  return _mat;
}

- (WLMesh *)mesh
{
  return _mesh;;
}
@end
