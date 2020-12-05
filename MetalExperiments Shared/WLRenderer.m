//
// Created by Sidharth Juyal on 25/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
//

#import "WLRenderer.h"
#import "WLActor.h"
#import "WLCamera.h"
#import "WLImage.h"
#import "WLMath.h"
#import "WLMesh.h"

const WLRendererConfig gConfig = {
  .pixelFormat = MTLPixelFormatBGRA8Unorm,
  .depthFormat = MTLPixelFormatDepth32Float,
};

@interface WLRenderer () {
  id<MTLDevice> _device;
  id<MTLLibrary> _lib;
  id<MTLRenderPipelineState> _pipeline;
  id<MTLDepthStencilState> _depth;
  id<MTLCommandQueue> _cmdQueue;
  id<MTLTexture> _depthTexture;
}
@end

@implementation WLRenderer

- (instancetype)init
{
  self = [super init];
  if (self) {
    _device = MTLCreateSystemDefaultDevice();
  }
  return self;
}

- (id<MTLDevice>)device
{
  return _device;
  ;
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

  MTLDepthStencilDescriptor *depthDesc = [[MTLDepthStencilDescriptor alloc] init];
  depthDesc.depthCompareFunction = MTLCompareFunctionLess;
  depthDesc.depthWriteEnabled = YES;
  _depth = [_device newDepthStencilStateWithDescriptor:depthDesc];

  _cmdQueue = [_device newCommandQueue];
}

- (void)resize:(CGSize)size
{
  MTLTextureDescriptor *depthTexDesc = [MTLTextureDescriptor
    texture2DDescriptorWithPixelFormat:gConfig.depthFormat
                                 width:size.width
                                height:size.height
                             mipmapped:NO];
  depthTexDesc.usage = MTLTextureUsageRenderTarget;
  depthTexDesc.storageMode = MTLStorageModePrivate;
  _depthTexture = [_device newTextureWithDescriptor:depthTexDesc];
}

- (void)renderScene:(WLScene *)scene
            texture:(id<MTLTexture>)texture
           drawable:(id<MTLDrawable>)drawable;
{
  id<MTLCommandBuffer> cmdBuf = [_cmdQueue commandBuffer];
  id<MTLRenderCommandEncoder> command = [self renderCommandWithTexture:texture
                                                            loadAction:MTLLoadActionClear
                                                                cmdBuf:cmdBuf];
  [scene render:command];
  [command endEncoding];
  [cmdBuf presentDrawable:drawable];
  [cmdBuf commit];

  [cmdBuf waitUntilCompleted];
}

- (id<MTLRenderCommandEncoder>)renderCommandWithTexture:(id<MTLTexture>)texture
                                             loadAction:(MTLLoadAction)loadAction
                                                 cmdBuf:(id<MTLCommandBuffer>)cmdBuf
{
  MTLRenderPassDescriptor *passDesc = [MTLRenderPassDescriptor renderPassDescriptor];
  passDesc.colorAttachments[0].texture = texture;
  passDesc.colorAttachments[0].loadAction = loadAction;
  passDesc.colorAttachments[0].storeAction = MTLStoreActionStore;
  passDesc.colorAttachments[0].clearColor = MTLClearColorMake(0.5, 0.5, 0.5, 1);
  passDesc.depthAttachment.texture = _depthTexture;
  passDesc.depthAttachment.clearDepth = 1.0f;
  passDesc.depthAttachment.loadAction = MTLLoadActionClear;
  passDesc.depthAttachment.storeAction = MTLStoreActionDontCare;

  id<MTLRenderCommandEncoder> command = [cmdBuf renderCommandEncoderWithDescriptor:passDesc];
  [command setRenderPipelineState:_pipeline];
  [command setDepthStencilState:_depth];
  [command setFrontFacingWinding:MTLWindingCounterClockwise];
  [command setCullMode:MTLCullModeBack];

  return command;
}

@end
