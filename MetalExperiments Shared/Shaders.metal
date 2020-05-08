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

//constant Light gLight = {
//  .position = { 5.0, 5.0, 2.0, 0.0f },
//  .La = { 0.0, 0.0, 0.0 },
//  .Ld = { 1.0, 1.0, 1.0 },
//};

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

struct Spotlight {
  Light light;
  float3 direction;
  float exponent;
  float cutoff;
};

struct Uniforms {
  float4x4 mvMatrix;
  float3x3 nMatrix;
  float4x4 mvpMatrix;
  float spotlightAngle;
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

//float4 getColor(const float4 position, const float3 normal, const Spotlight spotlight)
//{
//  float3 ambient = spotlight.light.La * gMaterial.Ka;
//
//  float3 diffuse = float3(0.0f);
//  float3 s = normalize(float3(spotlight.light.position) - float3(position));
//  float3 n = normalize(normal);
//  float diffuseFactor = max(0.0, dot(s, n));
//  diffuse = diffuseFactor * gMaterial.Kd * max(0.0f, dot(normal, s.xyz));
//
//  float3 spec = float3(0.0);
//  float3 v = normalize(-position.xyz);
//  float3 h = normalize(v + s);
//  spec = gMaterial.Ks * pow(max(0.0f, dot(h, n)), gMaterial.shine);
//
//  return float4(ambient + diffuse + spec, 1.0);
//}

float4 getColor(const float4 position, const float3 normal, const Spotlight spotlight)
{
  // ambient light
  float3 ambient = spotlight.light.La * gMaterial.Ka;
  float3 diffuse = float3(0.0f);
  float3 spec = float3(0.0);

  float3 s = normalize(float3(spotlight.light.position) - float3(position));

  float angleFactor = dot(-s, normalize(spotlight.direction)); // angle between light and spotlight dir
  float angle = acos(angleFactor); // spotlight angle


  if (angle < spotlight.cutoff) {
    float spotFactor = pow(angleFactor, spotlight.exponent);

    float3 n = normalize(normal);
    float diffuseFactor = max(0.0, dot(s, n));
    diffuse = spotFactor * diffuseFactor * gMaterial.Kd * spotlight.light.Ld;

    float3 v = normalize(-position.xyz);
    float3 h = normalize(v + s);
    spec = spotFactor * gMaterial.Ks * spotlight.light.Ld * pow(max(0.0f, dot(h, n)), gMaterial.shine);
  }

  return float4(ambient + diffuse + spec, 1.0);
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
  Spotlight spotlight = {
    .light = {
      .position = { 0.0, 20.0, 0.0, 1.0f },
      .La = { 0.5, 0.5, 0.5 },
      .Ld = { 0.9f, 0.9f, 0.9f },
    },
    .direction = { 0.0, 0.0, 0.0 },
    .exponent = 20.0f,
    .cutoff = 0.0f
  };
  spotlight.cutoff = M_PI_2_F;
  spotlight.direction = normalize(-spotlight.light.position.xyz);

  float positionFactor = 10.0f;
  spotlight.light.position.x = cos(uniforms.spotlightAngle) * positionFactor;
  spotlight.light.position.z = sin(uniforms.spotlightAngle) * positionFactor;

  return getColor(v.wPos, v.wNormal, spotlight);
}
