//
// Created by Sidharth Juyal on 20/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#import "WLRenderView.h"
#import <Quartz/Quartz.h>
#import <Metal/Metal.h>

@interface WLRenderView ()
{
  CAMetalLayer *_metalLayer;
  id<MTLDevice> _device;
}
@end

@implementation WLRenderView

- (void)setUp
{
  [self setWantsLayer:YES];
  _metalLayer = [CAMetalLayer layer];
  [_metalLayer setFrame:self.frame];
  [self setLayer:_metalLayer];

  _device = MTLCreateSystemDefaultDevice();
  _metalLayer.device = _device;
  _metalLayer.pixelFormat = MTLPixelFormatBGRA8Unorm;
}

- (void)redraw
{
  id<CAMetalDrawable> drawable = [_metalLayer nextDrawable];
  id<MTLTexture> texture = drawable.texture;

  MTLRenderPassDescriptor *passDesc = [MTLRenderPassDescriptor renderPassDescriptor];
  passDesc.colorAttachments[0].texture = texture;
  passDesc.colorAttachments[0].loadAction = MTLLoadActionClear;
  passDesc.colorAttachments[0].storeAction = MTLStoreActionStore;
  passDesc.colorAttachments[0].clearColor = MTLClearColorMake(1, 0, 0, 1);

  id<MTLCommandQueue> cmdQ = [_device newCommandQueue]; // not cheap

  id<MTLCommandBuffer> cmdBuf = [cmdQ commandBuffer];

  // .. draw calls

  id<MTLRenderCommandEncoder> cmdEnc = [cmdBuf renderCommandEncoderWithDescriptor:passDesc];
  [cmdEnc endEncoding];

  [cmdBuf presentDrawable:drawable];
  [cmdBuf commit];
}


@end
