//
// Created by Sidharth Juyal on 10/05/2020.
// Copyright © 2020 whackylabs. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WLImage : NSObject
/// Initialize this image by loading a *very* simple TGA file.  Will not load compressed, paletted,
//    or color mapped images.
- (instancetype)initWithLocation:(NSURL *)fileURL;

// Width of image in pixels
@property (nonatomic, readonly) NSUInteger width;

// Height of image in pixels
@property (nonatomic, readonly) NSUInteger height;

// Image data in 32-bits-per-pixel (bpp) BGRA form (which is equivalent to MTLPixelFormatBGRA8Unorm)
@property (nonatomic, readonly) NSData *data;

@end

NS_ASSUME_NONNULL_END
