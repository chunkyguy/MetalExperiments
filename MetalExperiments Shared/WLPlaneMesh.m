//
// Created by Sidharth Juyal on 28/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#import "WLPlaneMesh.h"
#import "WLTypes.h"

@interface WLPlaneMesh ()
{
  id<MTLBuffer> _vertexBuffer;
  id<MTLBuffer> _indexBuffer;
}
@end

@implementation WLPlaneMesh
- (instancetype)initWithDevice:(id<MTLDevice>)device
{
  self = [super initWithDevice:device];
  if (self) {

    WLVertex vertices[] = {
      {
        .position = { -1.0f, 1.0f, 0.0f, 1.0f},
        .normal = { 0.0f, 0.0f, 1.0f },
        .texCoord = { 0.0f, 0.0f }
      },
      {
        .position = { -1.0f, -1.0f, 0.0f, 1.0f },
        .normal = { 0.0f, 0.0f, 1.0f },
        .texCoord = { 0.0f, 1.0f }
      },
      {
        .position = { 1.0f, -1.0f, 0.0f, 1.0f },
        .normal = { 0.0f, 0.0f, 1.0f },
        .texCoord = { 1.0f, 1.0f }
      },
      {
        .position = { 1.0f, 1.0f, 0.0f, 1.0f },
        .normal = { 0.0f, 0.0f, 1.0f },
        .texCoord = { 1.0f, 0.0f }
      },
    };

    _vertexBuffer = [device newBufferWithBytes:vertices
                                        length:sizeof(vertices)
                                       options:MTLResourceOptionCPUCacheModeDefault];

    WLInt16 indices[] = {
      // front
      0, 1, 2,
      2, 3, 0,

      // back
      7, 6, 5,
      5, 4, 7,
    };
    _indexBuffer  = [device newBufferWithBytes:indices
                                         length:sizeof(indices)
                                        options:MTLResourceOptionCPUCacheModeDefault];
  }
  return self;
}

- (void)render:(id<MTLRenderCommandEncoder>)command
{
  [command setVertexBuffer:_vertexBuffer offset:0 atIndex:0];
  [command drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                     indexCount:[_indexBuffer length]/sizeof(WLInt16)
                      indexType:MTLIndexTypeUInt16
                    indexBuffer:_indexBuffer
              indexBufferOffset:0];
}
@end
