//
// Created by Sidharth Juyal on 26/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
//

#import "WLResourceMesh.h"
#import "MBEOBJGroup.h"
#import "MBEOBJModel.h"
#import "WLShaderTypes.h"
#import "WLUtils.h"

@interface WLResourceMesh () {
  MBEOBJGroup *_model;
  id<MTLBuffer> _vertexBuffer;
  id<MTLBuffer> _indexBuffer;
}
@end

@implementation WLResourceMesh
- (instancetype)initWithDevice:(id<MTLDevice>)device
                      resource:(NSURL *)resource
{
  self = [super initWithDevice:device];
  if (self) {
    MBEOBJModel *model = [[MBEOBJModel alloc] initWithContentsOfURL:resource generateNormals:NO];
    _model = [[model groups] firstObject];
    [self loadBuffers];
  }
  return self;
}

- (void)render:(id<MTLRenderCommandEncoder>)command
{
  [command setVertexBuffer:_vertexBuffer offset:0 atIndex:0];
  [command drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                      indexCount:[_indexBuffer length] / sizeof(WLInt16)
                       indexType:MTLIndexTypeUInt16
                     indexBuffer:_indexBuffer
               indexBufferOffset:0];
}

- (void)loadBuffers
{
  _vertexBuffer = [self.device newBufferWithBytes:[_model.vertexData bytes]
                                           length:[_model.vertexData length]
                                          options:MTLResourceOptionCPUCacheModeDefault];

  _indexBuffer = [self.device newBufferWithBytes:[_model.indexData bytes]
                                          length:[_model.indexData length]
                                         options:MTLResourceOptionCPUCacheModeDefault];
}
@end
