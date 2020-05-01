//
// Created by Sidharth Juyal on 28/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#import "WLActor.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WLPlaneDirection) {
  WLPlaneDirectionBottom,
  WLPlaneDirectionTop,
  WLPlaneDirectionLeft,
  WLPlaneDirectionRight,
  WLPlaneDirectionBack,
  WLPlaneDirectionFront
};

@interface WLPlane : WLActor
- (instancetype)initWithDevice:(id<MTLDevice>)device
                     direction:(WLPlaneDirection)direction;
@end

NS_ASSUME_NONNULL_END
