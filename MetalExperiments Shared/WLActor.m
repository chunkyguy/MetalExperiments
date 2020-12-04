//
// Created by Sidharth Juyal on 26/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
//

#import "WLActor.h"
#import "WLMath.h"
#import "WLTypes.h"
#import "WLUtils.h"
#import <MetalKit/MTKTextureLoader.h>

@interface WLActor () {
  id<MTLBuffer> _uniforms;
  NSMutableArray *_textures;
  MTKTextureLoader *_texLoader;
}
@end

@implementation WLActor

- (instancetype)initWithDevice:(id<MTLDevice>)device
{
  self = [super init];
  if (self) {
    _uniforms = [device newBufferWithLength:sizeof(WLUniforms)
                                    options:MTLResourceOptionCPUCacheModeDefault];
    _texLoader = [[MTKTextureLoader alloc] initWithDevice:device];
    _textures = [NSMutableArray array];
  }
  return self;
  ;
}

- (void)setTextureNames:(NSArray *)textureNames
{
  for (NSString *textureName in textureNames) {
    id<MTLTexture> texture = [_texLoader newTextureWithContentsOfURL:[WLUtils resourceNamed:textureName]
                                                             options:@{ MTKTextureLoaderOptionOrigin : MTKTextureLoaderOriginBottomLeft }
                                                               error:nil];
    NSParameterAssert(error == nil);
    [_textures addObject:texture];
  }
}

- (void)update:(float)dt
{
}

- (matrix_float4x4)modelMatrix
{
  return matrix_identity_float4x4;
}

- (WLMesh *)mesh
{
  WLAssertionFailure(@"Needs to be subclassed");
  return nil;
}

- (void)render:(id<MTLRenderCommandEncoder>)command
        camera:(WLCamera *)camera
{
  matrix_float4x4 mMatrix = self.modelMatrix;
  matrix_float4x4 mvMatrix = matrix_multiply(camera.viewMatrix, mMatrix);
  matrix_float3x3 nMatrix = simd_transpose(simd_inverse(wl_convert(mvMatrix)));

  WLUniforms *uniform = [_uniforms contents];
  uniform->mvMatrix = mvMatrix;
  uniform->nMatrix = nMatrix;
  uniform->mvpMatrix = matrix_multiply(camera.projMatrix, mvMatrix);

  [command setVertexBuffer:_uniforms offset:0 atIndex:1];
  [command setFragmentBuffer:_uniforms offset:0 atIndex:0];
  for (NSInteger texIndex = 0; texIndex < [_textures count]; ++texIndex) {
    [command setFragmentTexture:[_textures objectAtIndex:texIndex] atIndex:texIndex];
  }

  // set actor position info
  [self.mesh render:command];
}

@end
