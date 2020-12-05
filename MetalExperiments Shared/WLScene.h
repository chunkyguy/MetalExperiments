//
// Created by Sidharth Juyal on 27/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
//

#import "WLCamera.h"
#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

NS_ASSUME_NONNULL_BEGIN

@interface WLScene : NSObject
- (void)setUp:(id<MTLDevice>)device;
- (void)update:(float)dt
         event:(WLKeyEvent)event;
- (void)render:(id<MTLRenderCommandEncoder>)command;
@end

NS_ASSUME_NONNULL_END
