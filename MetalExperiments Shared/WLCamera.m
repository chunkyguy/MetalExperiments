//
// Created by Sidharth Juyal on 26/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#import "WLCamera.h"
#import "WLMath.h"

@interface WLCamera ()
{
  matrix_float4x4 _projMatrix;
  simd_float2 _camRotation;
}
@end

@implementation WLCamera

+ (instancetype)camera
{
  return [[self alloc] init];
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    _camRotation.x = 0.0f;
    _camRotation.y = 0.0f;

    float fov = (2.0f * M_PI)/5.0f;
    float aspect = 1.0f;
    _projMatrix = wl_perspective(fov, aspect, 1.0f, 100.0f);
    
  }
  return self;
}

- (matrix_float4x4)viewMatrix
{
  matrix_float4x4 xRotMat = wl_rotation(_camRotation.x, simd_make_float3(1.0f, 0.0f, 0.0f));
  matrix_float4x4 yRotMat = wl_rotation(_camRotation.y, simd_make_float3(0.0f, 1.0f, 0.0f));
  matrix_float4x4 tMat = wl_translation_float3(simd_make_float3(0.0f, 0.0f, -2.0f));
  return matrix_multiply(tMat, matrix_multiply(xRotMat, yRotMat));
}

- (matrix_float4x4)projMatrix
{
  return _projMatrix;
}

- (void)updateEvent:(WLKeyEvent)event
{
  float offset = 0.01f;

  switch (event) {
    case WLKeyEventLeft: _camRotation.y -= offset; break;
    case WLKeyEventRight: _camRotation.y += offset; break;
    case WLKeyEventUp: _camRotation.x += offset; break;
    case WLKeyEventDown: _camRotation.x -= offset; break;
    default: break;
  }
  _camRotation.x = wlRegionClam(_camRotation.x, 0.0f, kTau);
  _camRotation.y = wlRegionClam(_camRotation.y, 0.0f, kTau);
}

@end
