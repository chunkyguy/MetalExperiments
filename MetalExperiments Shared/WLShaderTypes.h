//
// Created by Sidharth Juyal on 12/05/2020.
// Copyright © 2020 whackylabs. All rights reserved.
//

#ifndef WLShaderTypes_h
#define WLShaderTypes_h

#import <simd/simd.h>

#ifdef __METAL_VERSION__
#define ATTRIB_POSITION [[position]]
#else
#define ATTRIB_POSITION
#endif

typedef struct _WLVertex {
  simd_float4 position ATTRIB_POSITION;
  simd_float3 normal;
  simd_float2 texCoords;
  //  simd_float3 tangent;
  //  simd_float3 binoarml;
} WLVertex;

typedef uint16_t WLInt16;

typedef struct _WLUniforms {
  simd_float4x4 mvMatrix;
  simd_float3x3 nMatrix;
  simd_float4x4 mvpMatrix;
} WLUniforms;

#endif /* WLShaderTypes_h */
