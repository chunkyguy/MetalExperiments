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
  vector_float4 color;
} WLVertex;

typedef uint16_t WLInt16;

typedef struct _WLUniforms {
  matrix_float4x4 mvpMatrix;
} WLUniforms;

#endif /* WLTypes_h */
