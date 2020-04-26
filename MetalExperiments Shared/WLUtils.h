//
// Created by Sidharth Juyal on 26/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#import <Foundation/Foundation.h>
#import <simd/simd.h>

NS_ASSUME_NONNULL_BEGIN

#define WLAssertionFailure(desc, ...) NSAssert(false, desc, ##__VA_ARGS__)

vector_float4 wl_whiteColor(float value);

@interface WLUtils : NSObject

@end

NS_ASSUME_NONNULL_END
