//
// Created by Sidharth Juyal on 26/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import <simd/simd.h>

NS_ASSUME_NONNULL_BEGIN

@class WLMesh;

@interface WLActor : NSObject
+ (instancetype)actorWithMesh:(WLMesh *)mesh;
- (void)update:(float)dt;

@property (nonatomic) matrix_float4x4 mat;
@property (nonatomic, readonly) WLMesh *mesh;
@end

NS_ASSUME_NONNULL_END
