//
// Created by Sidharth Juyal on 26/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#import "WLResourceMesh.h"
#import "WLUtils.h"
#import "WLTypes.h"
#import "MBEOBJModel.h"
#import "MBEOBJGroup.h"

@interface WLResourceMesh ()
{
  MBEOBJGroup *_model;
  id<MTLBuffer> _vertexBuffer;
  id<MTLBuffer> _indexBuffer;
}
@end

@implementation WLResourceMesh
- (instancetype)initWithDevice:(id<MTLDevice>)device
                      resource:(NSURL *)resource
                          name:(NSString *)name;
{
  self = [super initWithDevice:device];
  if (self) {
    MBEOBJModel *model = [[MBEOBJModel alloc] initWithContentsOfURL:resource generateNormals:YES];
    _model = [model groupForName:name];

  }
  return self;
}

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

  _vertexBuffer = [self.device newBufferWithBytes:[_model.vertexData bytes]
                                      length:[_model.vertexData length]
                                     options:MTLResourceOptionCPUCacheModeDefault];
  [_vertexBuffer setLabel:[NSString stringWithFormat:@"Vertices (%@)", _model.name]];

  return _vertexBuffer;
}

- (id<MTLBuffer>)indexBuffer
{
    if (_indexBuffer) {
    return _indexBuffer;
  }

  _indexBuffer = [self.device newBufferWithBytes:[_model.indexData bytes]
                                     length:[_model.indexData length]
                                    options:MTLResourceOptionCPUCacheModeDefault];
  [_indexBuffer setLabel:[NSString stringWithFormat:@"Indices (%@)", _model.name]];
  return _indexBuffer;
}
@end
