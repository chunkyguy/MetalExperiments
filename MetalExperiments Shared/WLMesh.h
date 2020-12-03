//
// Created by Sidharth Juyal on 25/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Metal/Metal.h>

@interface WLMesh : NSObject

- (instancetype)initWithDevice:(id<MTLDevice>)device;
- (void)render:(id<MTLRenderCommandEncoder>)command;

@property (nonatomic, readonly) id<MTLDevice> device;
@end
