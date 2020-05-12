//
// Created by Sidharth Juyal on 25/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#import "WLRenderer.h"
#import "WLTypes.h"
#import "WLMath.h"
#import "WLMesh.h"
#import "WLCamera.h"
#import "WLActor.h"
#import "WLImage.h"

const WLRendererConfig gConfig = {
  .pixelFormat = MTLPixelFormatBGRA8Unorm,
  .depthFormat = MTLPixelFormatDepth32Float,
};

@interface WLRenderer ()
{
  id<MTLDevice> _device;
  id<MTLLibrary> _lib;
  id<MTLRenderPipelineState> _pipeline;
  id<MTLDepthStencilState> _depth;
  id<MTLCommandQueue> _cmdQueue;
  id<MTLTexture> _depthTexture;

  id<MTLTexture> _texture;
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

  MTLDepthStencilDescriptor *depthDesc = [[MTLDepthStencilDescriptor alloc] init];
  depthDesc.depthCompareFunction = MTLCompareFunctionLess;
  depthDesc.depthWriteEnabled = YES;
  _depth = [_device newDepthStencilStateWithDescriptor:depthDesc];

  _cmdQueue = [_device newCommandQueue];

  [self loadTexture];
}

- (void)loadTexture
{
  NSURL *loc = [[NSBundle mainBundle] URLForResource:@"utc32" withExtension:@"tga"];
  WLImage *image = [[WLImage alloc] initWithLocation:loc];
  MTLTextureDescriptor *texDesc = [MTLTextureDescriptor
                                   texture2DDescriptorWithPixelFormat:MTLPixelFormatBGRA8Unorm
                                   width:image.width
                                   height:image.height
                                   mipmapped:NO];
  _texture = [_device newTextureWithDescriptor:texDesc];
  NSUInteger bytesPerRow = image.width * 4;
  MTLRegion region = MTLRegionMake2D(0, 0, image.width, image.height);
  [_texture replaceRegion:region mipmapLevel:0 withBytes:image.data.bytes bytesPerRow:bytesPerRow];
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
  [command setFragmentTexture:_texture atIndex:0];
  for (NSInteger i = 0; i < scene.actors.count; ++i) {
    [[scene.actors objectAtIndex:i] render:command
                                    camera:scene.camera];
  }
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
