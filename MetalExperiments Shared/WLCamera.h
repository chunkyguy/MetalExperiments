//
// Created by Sidharth Juyal on 26/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import <simd/simd.h>

NS_ASSUME_NONNULL_BEGIN

@interface WLCamera : NSObject

+ (instancetype)camera;

@property (nonatomic, readonly) matrix_float4x4 viewMatrix;
@property (nonatomic, readonly) matrix_float4x4 projMatrix;

@end

NS_ASSUME_NONNULL_END