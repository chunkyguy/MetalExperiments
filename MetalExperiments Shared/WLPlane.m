//
// Created by Sidharth Juyal on 28/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
//

#import "WLPlane.h"
#import "WLMath.h"
#import "WLPlaneMesh.h"

@interface WLPlane () {
  WLMesh *_mesh;
  matrix_float4x4 _mat;
}
@end

@implementation WLPlane

- (instancetype)initWithDevice:(id<MTLDevice>)device
                     direction:(WLPlaneDirection)direction;
{
  self = [super initWithDevice:device];
  if (self) {
    _mesh = [[WLPlaneMesh alloc] initWithDevice:device];

    vector_float4 axisAngle = { .0f, .0f, .0f, .0f };
    vector_float3 translate = { .0f, .0f, 0.0f };
    switch (direction) {
    case WLPlaneDirectionBottom:
      axisAngle.x = 1;
      axisAngle.w = -M_PI * 0.5f;
      translate.y = -6.9f;
      translate.z = 0.0f;
      break;

    case WLPlaneDirectionTop:
      axisAngle.x = 1;
      axisAngle.w = M_PI * 0.5f;
      translate.y = -6.9f;
      translate.z = -12.0f;
      break;

    case WLPlaneDirectionLeft:
      axisAngle.y = 1;
      axisAngle.w = M_PI * .49f;
      translate.x = -5.0f;
      translate.y = 0.0f;
      break;

    case WLPlaneDirectionRight:
      axisAngle.y = 1;
      axisAngle.w = -M_PI * .49f;
      translate.x = 5.0f;
      break;

    case WLPlaneDirectionBack:
      axisAngle.z = 1.0f;
      translate.z = -12.0f;
      break;

    case WLPlaneDirectionFront:
      translate.z = -2.0f;
      axisAngle.z = 1.0f;
      break;

    default:
      break;
    }

    matrix_float4x4 sMat = wl_scale(100, 100, 1);
    matrix_float4x4 rMat = wl_rotation_axis_angle(axisAngle);
    matrix_float4x4 tMat = wl_translation_float3(translate);

    _mat = matrix_multiply(tMat, matrix_multiply(rMat, sMat));
  }
  return self;
}

- (matrix_float4x4)modelMatrix
{
  return _mat;
}

- (WLMesh *)mesh
{
  return _mesh;
  ;
}
@end
