//
// Created by Sidharth Juyal on 26/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#import "WLCamera.h"
#import "WLMath.h"

@interface WLCamera ()
{
  matrix_float4x4 _viewMatrix;
  matrix_float4x4 _projMatrix;
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
    vector_float3 cam = {0, 0, -5};
    _viewMatrix = matrix4x4_translation_float3(cam);
    
    float fov = (2 * M_PI)/5.0f;
    float aspect = 1.0f;
    _projMatrix = matrix_perspective_right_hand(fov, aspect, 1.0f, 100.0f);
    
  }
  return self;
}

- (matrix_float4x4)viewMatrix
{
  return _viewMatrix;
}

- (matrix_float4x4)projMatrix
{
  return _projMatrix;
}

@end
