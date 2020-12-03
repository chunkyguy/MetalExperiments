//
// Created by Sidharth Juyal on 26/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
//

#import "WLUtils.h"

vector_float4 wl_whiteColor(float value)
{
  return (vector_float4) { value, value, value, 1.0 };
}

@implementation WLUtils
+ (NSURL *)resourceNamed:(NSString *)name
{
  NSArray *comps = [name componentsSeparatedByString:@"."];
  return [[NSBundle mainBundle] URLForResource:[comps firstObject]
                                 withExtension:[comps lastObject]];
}
@end
