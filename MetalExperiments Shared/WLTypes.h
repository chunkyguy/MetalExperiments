//
// Created by Sidharth Juyal on 25/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#ifndef WLTypes_h
#define WLTypes_h
#import <simd/simd.h>

// Types shared between app and shader

typedef struct _WLVertex {
  vector_float4 position;
  vector_float3 normal;
} WLVertex;

typedef uint16_t WLInt16;

typedef struct _WLUniforms {
  matrix_float4x4 mvMatrix;
  matrix_float3x3 nMatrix;
  matrix_float4x4 mvpMatrix;
  float spotlightAngle;
} WLUniforms;

typedef NS_ENUM(NSUInteger, WLKeyEvent) {
  WLKeyEventUp,
  WLKeyEventDown,
  WLKeyEventLeft,
  WLKeyEventRight,
  WLKeyEventIdle
};

#endif /* WLTypes_h */
