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
+ (instancetype)meshWithDevice:(id<MTLDevice>)device
{
  return [[self alloc] initWithDevice:device];
}

- (instancetype)initWithDevice:(id<MTLDevice>)device
{
  self = [super init];
  if (self) {
    _device = device;
  }
  return self;
}

- (id<MTLBuffer>)vertexBuffer
{
  WLAssertionFailure(@"Not implemented");
  return nil;
}

- (id<MTLBuffer>)indexBuffer
{
  WLAssertionFailure(@"Not implemented");
  return nil;
}
@end
