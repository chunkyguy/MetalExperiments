//
// Created by Sidharth Juyal on 27/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#import "WLActor.h"
#import <Metal/Metal.h>
#import <simd/simd.h>
NS_ASSUME_NONNULL_BEGIN

@interface WLTeapot : WLActor
- (instancetype)initWithDevice:(id<MTLDevice>)device
                      position:(simd_float3)position;
@end

NS_ASSUME_NONNULL_END
