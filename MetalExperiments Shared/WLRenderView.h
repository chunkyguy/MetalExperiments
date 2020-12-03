//
// Created by Sidharth Juyal on 20/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
//

#import <TargetConditionals.h>

#if TARGET_OS_IOS
#import <UIKit/UIKit.h>
#define WLView UIView
#elif TARGET_OS_OSX
#import <Cocoa/Cocoa.h>
#define WLView NSView
#endif

NS_ASSUME_NONNULL_BEGIN

@interface WLRenderView : WLView
- (void)setUp;
- (void)redrawWithDeltaTime:(float)dt;
@end

NS_ASSUME_NONNULL_END
