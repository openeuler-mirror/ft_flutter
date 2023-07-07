// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef FLUTTER_FLOW_PAINT_UTILS_H_
#define FLUTTER_FLOW_PAINT_UTILS_H_

#include "include/core/SkCanvas.h"
#include "include/core/SkColor.h"
#include "include/core/SkRect.h"

namespace flutter {

void DrawCheckerboard(SkCanvas* canvas, SkColor c1, SkColor c2, int size);

void DrawCheckerboard(SkCanvas* canvas, const SkRect& rect);

}  // namespace flutter

#endif  // FLUTTER_FLOW_PAINT_UTILS_H_
