//
// Created by Sidharth Juyal on 27/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
//

#import "WLCamera.h"
#import "WLTypes.h"
#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

NS_ASSUME_NONNULL_BEGIN

@interface WLScene : NSObject
- (void)setUp:(id<MTLDevice>)device;
- (void)update:(float)dt
         event:(WLKeyEvent)event;

@property (nonatomic, readonly) WLCamera *camera;
@property (nonatomic, readonly) NSArray *actors;
@end

NS_ASSUME_NONNULL_END
