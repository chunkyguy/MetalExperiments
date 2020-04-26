//
// Created by Sidharth Juyal on 24/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#ifndef WLMath_h
#define WLMath_h

#include <simd/simd.h>

matrix_float4x4 wl_matrix4x4_translation(float tx, float ty, float tz);
matrix_float4x4 wl_matrix4x4_translation_float3(vector_float3 t);

matrix_float4x4 wl_matrix4x4_rotation(float radians, vector_float3 axis);
matrix_float4x4 wl_matrix_perspective_right_hand(float fovyRadians, float aspect, float nearZ, float farZ);

matrix_float3x3 wl_matrix_float4x4_extract_linear(matrix_float4x4 m);


#endif /* WLMath_h */
