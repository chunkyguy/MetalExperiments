//
// Created by Sidharth Juyal on 25/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>
#include <CoreGraphics/CoreGraphics.h>
#import "WLScene.h"

NS_ASSUME_NONNULL_BEGIN

typedef struct _WLRendererConfig {
  MTLPixelFormat pixelFormat;
  MTLPixelFormat depthFormat;
} WLRendererConfig;
extern const WLRendererConfig gConfig;

@interface WLRenderer : NSObject

- (void)setUp;
- (void)resize:(CGSize)size;
- (void)renderScene:(WLScene *)scene
            texture:(id<MTLTexture>)texture
           drawable:(id<MTLDrawable>)drawable;

@property (nonatomic, readonly) id<MTLDevice> device;
@end

NS_ASSUME_NONNULL_END
