//
// Created by Sidharth Juyal on 25/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
// 

#import "WLMesh.h"
#import "WLUtils.h"

@interface WLMesh ()
{
  id<MTLDevice> _device;
}
@end

@implementation WLMesh
- (instancetype)initWithDevice:(id<MTLDevice>)device
{
  self = [super init];
  if (self) {
    _device = device;
  }
  return self;
}


- (void)render:(id<MTLRenderCommandEncoder>)command
{
  WLAssertionFailure(@"Not implemented");
}

@end
