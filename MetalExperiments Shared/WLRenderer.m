//
// Created by Sidharth Juyal on 25/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#import "WLRenderer.h"
#import "WLTypes.h"
#import "WLMath.h"
#import "WLCubeMesh.h"
#import "WLActor.h"
#import "WLCamera.h"

const WLRendererConfig gConfig = {
  .pixelFormat = MTLPixelFormatBGRA8Unorm,
  .depthFormat = MTLPixelFormatDepth32Float,
};

@interface WLRenderer ()
{
  id<MTLDevice> _device;
  id<MTLLibrary> _lib;
  id<MTLRenderPipelineState> _pipeline;
  id<MTLCommandQueue> _cmdQueue;
  id<MTLDepthStencilState> _depth;
  id<MTLTexture> _depthTexture;
  id<MTLBuffer> _uniformBuffer;
  NSMutableArray *_actors;
  WLCamera *_camera;
}
@end

@implementation WLRenderer

- (instancetype)init
{
  self = [super init];
  if (self) {
    _actors = [NSMutableArray array];
    _camera = [WLCamera camera];
    _device = MTLCreateSystemDefaultDevice();
  }
  return self;
}

- (id<MTLDevice>)device
{
  return _device;;
}

- (void)setUp
{
  // pipeline
  _lib = [_device newDefaultLibrary];
  MTLRenderPipelineDescriptor *pipeDesc = [[MTLRenderPipelineDescriptor alloc] init];
  pipeDesc.vertexFunction = [_lib newFunctionWithName:@"vert_main"];
  pipeDesc.fragmentFunction = [_lib newFunctionWithName:@"frag_main"];
  pipeDesc.colorAttachments[0].pixelFormat = gConfig.pixelFormat;
  pipeDesc.depthAttachmentPixelFormat = gConfig.depthFormat;
  _pipeline = [_device newRenderPipelineStateWithDescriptor:pipeDesc error:nil];
  _cmdQueue = [_device newCommandQueue];

  MTLDepthStencilDescriptor *depthDesc = [[MTLDepthStencilDescriptor alloc] init];
  depthDesc.depthCompareFunction = MTLCompareFunctionLess;
  depthDesc.depthWriteEnabled = YES;
  _depth = [_device newDepthStencilStateWithDescriptor:depthDesc];

  _uniformBuffer = [_device newBufferWithLength:sizeof(WLUniforms)
                                        options:MTLResourceOptionCPUCacheModeDefault];

  [self addActor:[WLActor actorWithMesh:[WLCubeMesh meshWithDevice:_device]]];
}

- (void)resize:(CGSize)size
{
  MTLTextureDescriptor *depthTexDesc = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:gConfig.depthFormat
                                                                                          width:size.width
                                                                                         height:size.height
                                                                                      mipmapped:NO];
  depthTexDesc.usage = MTLTextureUsageRenderTarget;
  depthTexDesc.storageMode = MTLStorageModePrivate;
  _depthTexture = [_device newTextureWithDescriptor:depthTexDesc];
}

- (void)addActor:(WLActor *)actor
{
  [_actors addObject:actor];
}

- (void)update:(float)dt
{
  for (WLActor *actor in _actors) {
    [actor update:dt];
  }
}

- (void)renderWithTexture:(id<MTLTexture>)texture drawable:(id<MTLDrawable>)drawable;
{
  MTLRenderPassDescriptor *passDesc = [MTLRenderPassDescriptor renderPassDescriptor];

  passDesc.colorAttachments[0].texture = texture;
  passDesc.colorAttachments[0].loadAction = MTLLoadActionClear;
  passDesc.colorAttachments[0].storeAction = MTLStoreActionStore;
  passDesc.colorAttachments[0].clearColor = MTLClearColorMake(0.5, 0.5, 0.5, 1);

  passDesc.depthAttachment.texture = _depthTexture;
  passDesc.depthAttachment.clearDepth = 1.0f;
  passDesc.depthAttachment.loadAction = MTLLoadActionClear;
  passDesc.depthAttachment.storeAction = MTLStoreActionDontCare;

  for (WLActor *actor in _actors) {
    id<MTLCommandBuffer> cmdBuf = [_cmdQueue commandBuffer];
    id<MTLRenderCommandEncoder> cmdEnc = [cmdBuf renderCommandEncoderWithDescriptor:passDesc];

    // prepare command encoder
    [cmdEnc setDepthStencilState:_depth];
    [cmdEnc setFrontFacingWinding:MTLWindingCounterClockwise];
    [cmdEnc setCullMode:MTLCullModeBack];
    [cmdEnc setRenderPipelineState:_pipeline];

    // set actor position info
    WLUniforms uniforms = {
      .mvpMatrix = matrix_multiply(_camera.projMatrix, matrix_multiply(_camera.viewMatrix, actor.mat))
    };
    memcpy([_uniformBuffer contents], &uniforms, sizeof(uniforms));
    [cmdEnc setVertexBuffer:_uniformBuffer offset:0 atIndex:1];

    // set actor vertex info
    WLMesh *mesh = actor.mesh;
    [cmdEnc setVertexBuffer:mesh.vertexBuffer offset:0 atIndex:0];
    [cmdEnc drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                       indexCount:[mesh.indexBuffer length]/sizeof(WLInt16)
                        indexType:MTLIndexTypeUInt16
                      indexBuffer:mesh.indexBuffer
                indexBufferOffset:0];

    [cmdEnc endEncoding];

    [cmdBuf presentDrawable:drawable];
    [cmdBuf commit];
  }
}


@end

