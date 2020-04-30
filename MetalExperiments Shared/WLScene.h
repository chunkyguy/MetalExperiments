//
// Created by Sidharth Juyal on 27/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#import <Foundation/Foundation.h>
#include <Metal/Metal.h>

NS_ASSUME_NONNULL_BEGIN

@class WLCamera;

@interface WLScene : NSObject
- (void)setUp:(id<MTLDevice>)device;
- (void)update:(float)dt;

@property (nonatomic, readonly) WLCamera *camera;
@property (nonatomic, readonly) NSArray *actors;
@end

NS_ASSUME_NONNULL_END
