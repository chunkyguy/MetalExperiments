//
// Created by Sidharth Juyal on 26/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#import "WLCubeMesh.h"
#import "WLTypes.h"
#import "WLUtils.h"

@interface WLCubeMesh ()
{
  id<MTLBuffer> _vertexBuffer;
  id<MTLBuffer> _indexBuffer;
}
@end

@implementation WLCubeMesh

- (void)render:(id<MTLRenderCommandEncoder>)command
{
  [command setVertexBuffer:
   [self vertexBuffer] offset:0 atIndex:0];

  [command drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                     indexCount:[[self indexBuffer] length]/sizeof(WLInt16)
                      indexType:MTLIndexTypeUInt16
                    indexBuffer:[self indexBuffer]
              indexBufferOffset:0];

}

- (id<MTLBuffer>)vertexBuffer
{
  if (_vertexBuffer) {
    return _vertexBuffer;
  }

  WLVertex vertices[] = {
    {.position = {-1.0f, 1.0f, 1.0f, 1.0f}, .normal = {0.0f, 0.0f, 1.0f, 0.0f}},
    {.position = {-1.0f, -1.0f, 1.0f, 1.0f}, .normal = {0.0f, 0.0f, 1.0f, 0.0f}},
    {.position = {1.0f, -1.0f, 1.0f, 1.0f}, .normal = {0.0f, 0.0f, 1.0f, 0.0f}},
    {.position = {1.0f, 1.0f, 1.0f, 1.0f}, .normal = {0.0f, 0.0f, 1.0f, 0.0f}},

    {.position = {-1.0f, 1.0f, -1.0f, 1.0f}, .normal = {0.0f, 0.0f, -1.0f, 0.0f}},
    {.position = {-1.0f, -1.0f, -1.0f, 1.0f}, .normal = {0.0f, 0.0f, -1.0f, 0.0f}},
    {.position = {1.0f, -1.0f, -1.0f, 1.0f}, .normal = {0.0f, 0.0f, -1.0f, 0.0f}},
    {.position = {1.0f, 1.0f, -1.0f, 1.0f}, .normal = {0.0f, 0.0f, -1.0f, 0.0f}},
  };

  _vertexBuffer = [self.device newBufferWithBytes:vertices
                                       length:sizeof(vertices)
                                      options:MTLResourceOptionCPUCacheModeDefault];
  return _vertexBuffer;;
}

- (id<MTLBuffer>)indexBuffer
{

  if (_indexBuffer) {
    return _indexBuffer;
  }

  WLInt16 indices[] = {
    // front
    0, 1, 2,
    2, 3, 0,

    // back
    7, 6, 5,
    5, 4, 7,

    // left
    4, 5, 1,
    1, 0, 4,

    // right
    3, 2, 6,
    6, 7, 3,

    // top
    4, 0, 3,
    3, 7, 4,

    7, 4, 3,
    3, 4, 0,

    // bottom
    1, 5, 6,
    6, 2, 1,
  };

  _indexBuffer  = [self.device newBufferWithBytes:indices
                                       length:sizeof(indices)
                                      options:MTLResourceOptionCPUCacheModeDefault];
  return _indexBuffer;
}

@end
