//
// Created by Sidharth Juyal on 26/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
//

#import "WLMesh.h"

NS_ASSUME_NONNULL_BEGIN

@interface WLResourceMesh : WLMesh
- (instancetype)initWithDevice:(id<MTLDevice>)device
                      resource:(NSURL *)resource;
@end

NS_ASSUME_NONNULL_END
