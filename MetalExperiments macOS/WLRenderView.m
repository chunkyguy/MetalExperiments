//
// Created by Sidharth Juyal on 20/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#import "WLRenderView.h"
#import <Quartz/Quartz.h>
#import <Metal/Metal.h>
#import <simd/simd.h>

typedef struct _WLVertex {
  vector_float4 position;
  vector_float4 color;
} WLVertex;

@interface WLRenderView ()
{
  CAMetalLayer *_metalLayer;
  id<MTLDevice> _device;
  id<MTLCommandQueue> _cmdQueue;
  id<MTLBuffer> _buffer;
  id<MTLLibrary> _lib;
  MTLPixelFormat _pixelFormat;
  id<MTLRenderPipelineState> _pipeline;
}
@end

@implementation WLRenderView

- (void)setUp
{

  _pixelFormat = MTLPixelFormatBGRA8Unorm;

  [self setUpDevice];
  [self setUpBuffers];
  [self setUpPipeline];


  _cmdQueue = [_device newCommandQueue];
}

- (void)setUpDevice
{
  [self setWantsLayer:YES];
  _metalLayer = [CAMetalLayer layer];
  [_metalLayer setFrame:self.frame];
  [self setLayer:_metalLayer];

  _device = MTLCreateSystemDefaultDevice();
  _metalLayer.device = _device;
  _metalLayer.pixelFormat = _pixelFormat;
}

- (void)setUpBuffers
{
  WLVertex vertices[] = {
    {.position = {0.0f, 0.5f, 0.0f, 1.0f}, .color = {1.0f, 0.0f, 0.0f, 1.0f}},
    {.position = {-0.5f, -0.5f, 0.0f, 1.0f}, .color = {0.0f, 1.0f, 0.0f, 1.0f}},
    {.position = {0.5f, -0.5f, 0.0f, 1.0f}, .color = {0.0f, 0.0f, 1.0f, 1.0f}},
  };

  _buffer = [_device newBufferWithBytes:vertices length:sizeof(vertices) options:MTLResourceOptionCPUCacheModeDefault];
}

- (void)setUpPipeline
{
  _lib = [_device newDefaultLibrary];
  id<MTLFunction> vertFunc = [_lib newFunctionWithName:@"vert_main"];
  id<MTLFunction> fragFunc = [_lib newFunctionWithName:@"frag_main"];

  MTLRenderPipelineDescriptor *pipeDesc = [[MTLRenderPipelineDescriptor alloc] init];
  pipeDesc.vertexFunction = vertFunc;
  pipeDesc.fragmentFunction = fragFunc;
  pipeDesc.colorAttachments[0].pixelFormat = _pixelFormat;
  _pipeline = [_device newRenderPipelineStateWithDescriptor:pipeDesc error:nil];
}

- (void)redraw
{
  id<CAMetalDrawable> drawable = [_metalLayer nextDrawable];
  id<MTLTexture> texture = drawable.texture;


  id<MTLCommandBuffer> cmdBuf = [_cmdQueue commandBuffer];

  MTLRenderPassDescriptor *passDesc = [MTLRenderPassDescriptor renderPassDescriptor];
  passDesc.colorAttachments[0].texture = texture;
  passDesc.colorAttachments[0].loadAction = MTLLoadActionClear;
  passDesc.colorAttachments[0].storeAction = MTLStoreActionStore;
  passDesc.colorAttachments[0].clearColor = MTLClearColorMake(0.5, 0.5, 0.5, 1);
  id<MTLRenderCommandEncoder> cmdEnc = [cmdBuf renderCommandEncoderWithDescriptor:passDesc];
  [cmdEnc setRenderPipelineState:_pipeline];
  [cmdEnc setVertexBuffer:_buffer offset:0 atIndex:0];
  [cmdEnc drawPrimitives:MTLPrimitiveTypeTriangle vertexStart:0 vertexCount:3];
  [cmdEnc endEncoding];

  [cmdBuf presentDrawable:drawable];
  [cmdBuf commit];
}


@end
