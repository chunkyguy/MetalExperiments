//
// Created by Sidharth Juyal on 24/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
//

#ifndef WLMath_h
#define WLMath_h

#include <simd/simd.h>

extern const float kTau;

matrix_float4x4 wl_translation(float tx, float ty, float tz);
matrix_float4x4 wl_translation_float3(vector_float3 t);

matrix_float4x4 wl_scale(float sx, float sy, float sz);

matrix_float4x4 wl_rotation(float radians, vector_float3 axis);
matrix_float4x4 wl_rotation_axis_angle(vector_float4 axisAngle);

matrix_float4x4 wl_perspective(float fovyRadians, float aspect, float nearZ, float farZ);
matrix_float3x3 wl_convert(matrix_float4x4 m);

float wlRegionClam(float value, float min, float max);

#endif /* WLMath_h */
