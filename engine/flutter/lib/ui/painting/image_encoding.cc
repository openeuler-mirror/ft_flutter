// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "flutter/lib/ui/painting/image_encoding.h"

#include <memory>
#include <utility>

#include "flutter/common/task_runners.h"
#include "flutter/fml/build_config.h"
#include "flutter/fml/make_copyable.h"
#include "flutter/fml/trace_event.h"
#include "flutter/lib/ui/painting/image.h"
#include "flutter/lib/ui/ui_dart_state.h"
#include "include/core/SkCanvas.h"
#include "include/core/SkEncodedImageFormat.h"
#include "include/core/SkImage.h"
#include "include/core/SkSurface.h"

namespace flutter {

Dart_Handle EncodeImage(CanvasImage* canvas_image,
                        int format,
                        Dart_Handle callback_handle) {
  return nullptr;
}

}  // namespace flutter
