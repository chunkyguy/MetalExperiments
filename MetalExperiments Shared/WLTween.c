//
// Created by Sidharth Juyal on 05/12/2020.
// Copyright © 2020 whackylabs. All rights reserved.
//

#include "WLTween.h"

float linearTween(float t, float start, float end)
{
  return t * start + (1 - t) * end;
}

// quadratic ease-in
float easeIn(float t, float start, float end)
{
  return linearTween(t * t, start, end);
}

// quadratic ease-out
float easeInOut(float t, float start, float end)
{
  float middle = (start + end) / 2;
  t = 2 * t;
  if (t <= 1) {
    return linearTween(t * t, start, middle);
  }
  t -= 1;
  return linearTween(t * t, middle, end);
}
