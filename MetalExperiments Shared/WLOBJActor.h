//
// Created by Sidharth Juyal on 27/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
//

#import "WLActor.h"
#import <Metal/Metal.h>
#import <simd/simd.h>
NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WLOBJActorRotationSpeed) {
  WLOBJActorRotationSpeedNone,
  WLOBJActorRotationSpeedSlow,
  WLOBJActorRotationSpeedFast,
};

@interface WLOBJActor : WLActor
- (instancetype)initWithDevice:(id<MTLDevice>)device
                         named:(NSString *)name
                      position:(simd_float3)position;

- (void)setSpeed:(WLOBJActorRotationSpeed)speed;
@end

NS_ASSUME_NONNULL_END
