//
// Created by Sidharth Juyal on 26/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import <simd/simd.h>
#import <Metal/Metal.h>
#import "WLMesh.h"
#import "WLCamera.h"

NS_ASSUME_NONNULL_BEGIN

@interface WLActor : NSObject
- (instancetype)initWithDevice:(id<MTLDevice>)device;
- (void)update:(float)dt;
- (void)render:(id<MTLRenderCommandEncoder>)command
        camera:(WLCamera *)camera;

@property (nonatomic) matrix_float4x4 modelMatrix;
@property (nonatomic, readonly) WLMesh *mesh;
@end

NS_ASSUME_NONNULL_END
