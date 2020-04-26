//
// Created by Sidharth Juyal on 25/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct _WLRendererConfig {
  MTLPixelFormat pixelFormat;
  MTLPixelFormat depthFormat;
} WLRendererConfig;
extern const WLRendererConfig gConfig;

@class WLActor;

@interface WLRenderer : NSObject

- (void)setUp;
- (void)resize:(CGSize)size;
- (void)update:(float)dt;
- (void)renderWithTexture:(id<MTLTexture>)texture drawable:(id<MTLDrawable>)drawable;

- (void)addActor:(WLActor *)actor;

@property (nonatomic, readonly) id<MTLDevice> device;
@end

NS_ASSUME_NONNULL_END
