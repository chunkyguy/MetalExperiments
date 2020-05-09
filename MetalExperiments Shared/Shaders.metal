//
// Created by Sidharth Juyal on 20/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

// File for Metal kernel and shader functions

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct Light {
  float4 position;
  float3 La; // Ambient
  float3 Ld; // Diffuse
};
constant Light gLight = {
  .position = { 5.0, 5.0, 2.0, 0.0f },
  .La = { 0.2, 0.2, 0.2 },
  .Ld = { 1.0, 1.0, 1.0 },
};

struct Material {
  float3 Ka, Kd, Ks; // Reflectivity
  float shine;
};
constant Material gMaterial = {
  .Ka = { 0.9f * 0.3f, 0.5f * 0.3f, 0.3f * 0.3f },
  .Kd = { 0.9f, 0.5f, 0.3f },
  .Ks = { 0.8f, 0.8f, 0.8f },
  .shine = 30.0f
};

struct Fog {
  float2 dist;
  float3 color;
};
constant Fog gFog = {
  .dist = { 1.0f, 7.0f },
  .color = { 0.2f, 0.3f, 0.5f }
};
float3 addFog(const Fog fog, const float dist, const float3 color)
{
  float d = abs(dist);
  float fogFactor = ((fog.dist[1] - d)/(fog.dist[1] - fog.dist[0]));
  fogFactor = clamp(fogFactor, 0.0f, 1.0f);
  return mix(gFog.color, color.xyz, fogFactor);
}

struct Uniforms {
  float4x4 mvMatrix;
  float3x3 nMatrix;
  float4x4 mvpMatrix;
};

struct VertexIn {
  float4 position;
  float3 normal;
};

struct VertexOut {
  float4 position [[position]];
  float4 wPos;
  float3 wNormal;
};

float3 getColor(const float4 position, const float3 normal, const Light light)
{
  float3 ambient = light.La * gMaterial.Ka;

  float3 diffuse = float3(0.0f);
  float3 s = normalize(float3(light.position) - float3(position));
  float3 n = normalize(normal);
  float cosine = max(0.0, dot(s, n));
  diffuse = gMaterial.Kd * cosine * max(0.0f, dot(normal, s.xyz));

  float3 spec = float3(0.0);
  float3 v = normalize(-position.xyz);
  float3 h = normalize(v + s);
  spec = gMaterial.Ks * pow(max(0.0f, dot(h, n)), gMaterial.shine);

  return ambient + diffuse + spec;
}

vertex VertexOut vert_main(
  const device VertexIn *vertices [[buffer(0)]],
  constant Uniforms &uniforms [[buffer(1)]],
  uint vid [[vertex_id]]
)
{
  float4 wPos = uniforms.mvMatrix * vertices[vid].position;
  float3 wNormal = normalize(uniforms.nMatrix * vertices[vid].normal);

  VertexOut out {
    .position = uniforms.mvpMatrix * vertices[vid].position,
    .wPos = wPos,
    .wNormal = wNormal
  };
  return out;
}


fragment float4 frag_main(VertexOut v [[stage_in]], constant Uniforms &uniforms [[buffer(0)]])
{
  float3 color = getColor(v.wPos, v.wNormal, gLight);
  return float4(addFog(gFog, v.wPos.z, color), 1.0f);
}
