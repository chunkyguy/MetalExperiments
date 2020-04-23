//
// Created by Sidharth Juyal on 20/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#import "WLRenderView.h"
#import <Quartz/Quartz.h>
#import <Metal/Metal.h>
#import "WLMath.h"

typedef struct _WLVertex {
  vector_float4 position;
  vector_float4 color;
} WLVertex;

typedef uint16_t WLInt16;

typedef struct _WLUniforms {
  matrix_float4x4 mvpMatrix;
} WLUniforms;

@interface WLRenderView ()
{
  CAMetalLayer *_metalLayer;
  id<MTLDevice> _device;
  id<MTLCommandQueue> _cmdQueue;
  id<MTLLibrary> _lib;
  MTLPixelFormat _pixelFormat;
  MTLPixelFormat _depthFormat;
  id<MTLRenderPipelineState> _pipeline;
  id<MTLBuffer> _vertexBuffer;
  id<MTLBuffer> _indexBuffer;
  id<MTLBuffer> _uniformBuffer;
  id<MTLDepthStencilState> _depthState;
  id<MTLTexture> _depthTexture;
}
@end

@implementation WLRenderView

- (void)setUp
{

  _pixelFormat = MTLPixelFormatBGRA8Unorm;
  _depthFormat = MTLPixelFormatDepth32Float;

  [self setUpDevice];
  [self setUpTextures];
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
  _metalLayer.drawableSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
}

- (void)setUpTextures
{
  CGSize size = [_metalLayer drawableSize];
  MTLTextureDescriptor *desc = [MTLTextureDescriptor texture2DDescriptorWithPixelFormat:_depthFormat
                                                                                  width:size.width
                                                                                 height:size.height
                                                                              mipmapped:NO];
  desc.usage = MTLTextureUsageRenderTarget;
  desc.storageMode = MTLStorageModePrivate;
  _depthTexture = [_device newTextureWithDescriptor:desc];
}

#define make_grey(shade) {shade, shade, shade, 1.0f}

- (void)setUpBuffers
{
  WLVertex vertices[] = {
    {.position = {-1.0f, 1.0f, 1.0f, 1.0f}, .color = make_grey(0.3f)},
    {.position = {-1.0f, -1.0f, 1.0f, 1.0f}, .color = make_grey(0.9f)},
    {.position = {1.0f, -1.0f, 1.0f, 1.0f}, .color = make_grey(0.7f)},
    {.position = {1.0f, 1.0f, 1.0f, 1.0f}, .color = make_grey(0.2)},

    {.position = {-1.0f, 1.0f, -1.0f, 1.0f}, .color = make_grey(0.2f)},
    {.position = {-1.0f, -1.0f, -1.0f, 1.0f}, .color = make_grey(0.7f)},
    {.position = {1.0f, -1.0f, -1.0f, 1.0f}, .color = make_grey(0.0f)},
    {.position = {1.0f, 1.0f, -1.0f, 1.0f}, .color = make_grey(0.0f)},
  };

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

  _vertexBuffer = [_device newBufferWithBytes:vertices
                                       length:sizeof(vertices)
                                      options:MTLResourceOptionCPUCacheModeDefault];
  _indexBuffer  = [_device newBufferWithBytes:indices
                                       length:sizeof(indices)
                                      options:MTLResourceOptionCPUCacheModeDefault];
  _uniformBuffer = [_device newBufferWithLength:sizeof(WLUniforms)
                       options:MTLResourceOptionCPUCacheModeDefault];
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
  pipeDesc.depthAttachmentPixelFormat = _depthFormat;
  _pipeline = [_device newRenderPipelineStateWithDescriptor:pipeDesc error:nil];

  MTLDepthStencilDescriptor *depthStateDesc = [[MTLDepthStencilDescriptor alloc] init];
  depthStateDesc.depthCompareFunction = MTLCompareFunctionLess;
  depthStateDesc.depthWriteEnabled = YES;
  _depthState = [_device newDepthStencilStateWithDescriptor:depthStateDesc];
}

- (void)redrawWithDeltaTime:(float)dt;
{
  [self update:dt];
  [self render];
}

- (void)update:(float)dt
{
  vector_float3 axis = {0, 1, 0};
  matrix_float4x4 modelMatrix = matrix4x4_rotation(M_PI * 0.125, axis);

  vector_float3 cam = {0, 0, -5};
  matrix_float4x4 viewMatrix = matrix4x4_translation_float3(cam);
  float fov = (2 * M_PI)/5.0f;
  float aspect = 1.0f;
  matrix_float4x4 projMatrix = matrix_perspective_right_hand(fov, aspect, 1.0f, 100.0f);
  WLUniforms uniforms;
  uniforms.mvpMatrix = matrix_multiply(projMatrix, matrix_multiply(viewMatrix, modelMatrix));
  memcpy([_uniformBuffer contents], &uniforms, sizeof(uniforms));
}

- (void)render
{
  id<CAMetalDrawable> drawable = [_metalLayer nextDrawable];
  id<MTLTexture> texture = drawable.texture;


  id<MTLCommandBuffer> cmdBuf = [_cmdQueue commandBuffer];

  MTLRenderPassDescriptor *passDesc = [MTLRenderPassDescriptor renderPassDescriptor];

  passDesc.colorAttachments[0].texture = texture;
  passDesc.colorAttachments[0].loadAction = MTLLoadActionClear;
  passDesc.colorAttachments[0].storeAction = MTLStoreActionStore;
  passDesc.colorAttachments[0].clearColor = MTLClearColorMake(0.5, 0.5, 0.5, 1);

  passDesc.depthAttachment.texture = _depthTexture;
  passDesc.depthAttachment.clearDepth = 1.0f;
  passDesc.depthAttachment.loadAction = MTLLoadActionClear;
  passDesc.depthAttachment.storeAction = MTLStoreActionDontCare;

  id<MTLRenderCommandEncoder> cmdEnc = [cmdBuf renderCommandEncoderWithDescriptor:passDesc];

  [cmdEnc setDepthStencilState:_depthState];

  [cmdEnc setFrontFacingWinding:MTLWindingCounterClockwise];
  [cmdEnc setCullMode:MTLCullModeBack];

  [cmdEnc setRenderPipelineState:_pipeline];

  [cmdEnc setVertexBuffer:_vertexBuffer offset:0 atIndex:0];
  [cmdEnc setVertexBuffer:_uniformBuffer offset:0 atIndex:1];

  [cmdEnc drawIndexedPrimitives:MTLPrimitiveTypeTriangle
                     indexCount:[_indexBuffer length]/sizeof(WLInt16)
                      indexType:MTLIndexTypeUInt16
                    indexBuffer:_indexBuffer
              indexBufferOffset:0];

  [cmdEnc endEncoding];

  [cmdBuf presentDrawable:drawable];
  [cmdBuf commit];
}


@end
