//
// Created by Sidharth Juyal on 20/04/2020.
// Copyright © 2020 whackylabs. All rights reserved.
//

#import "GameViewController.h"
#import "WLRenderView.h"
#import <CoreVideo/CoreVideo.h>

static uint64_t _lastTime = 0;

static CVReturn callback(CVDisplayLinkRef CV_NONNULL displayLink,
  const CVTimeStamp *CV_NONNULL inNow,
  const CVTimeStamp *CV_NONNULL inOutputTime,
  CVOptionFlags flagsIn,
  CVOptionFlags *CV_NONNULL flagsOut,
  void *CV_NULLABLE displayLinkContext)
{
  uint64_t now = inNow->videoTime;
  float dt = 0.01f;
  if (_lastTime > 0) {
    dt = (now - _lastTime) / ((float)inNow->videoTimeScale);
  }
  _lastTime = now;
  [(__bridge WLRenderView *)displayLinkContext redrawWithDeltaTime:dt];
  return kCVReturnSuccess;
}

@interface GameViewController () {
  WLRenderView *_view;
  CVDisplayLinkRef _displayLink;
}
@end

@implementation GameViewController

- (void)viewDidLoad
{
  [super viewDidLoad];

  _view = (WLRenderView *)self.view;
  [_view setUp];

  CVDisplayLinkCreateWithActiveCGDisplays(&_displayLink);
  CVDisplayLinkSetOutputCallback(_displayLink, callback, (__bridge void *_Nullable)(_view));
}

- (void)viewDidAppear
{
  [super viewDidAppear];
  CVDisplayLinkStart(_displayLink);
}

- (void)viewDidDisappear
{
  [super viewDidDisappear];
  CVDisplayLinkStart(_displayLink);
}

@end
