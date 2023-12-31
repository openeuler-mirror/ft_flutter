// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef FLUTTER_LIB_UI_IO_MANAGER_H_
#define FLUTTER_LIB_UI_IO_MANAGER_H_

#include "flutter/flow/skia_gpu_object.h"
#include "flutter/fml/memory/weak_ptr.h"
#include "include/gpu/GrContext.h"

namespace flutter {
// Interface for methods that manage access to the resource GrContext and Skia
// unref queue.  Meant to be implemented by the owner of the resource GrContext,
// i.e. the shell's IOManager.
class IOManager {
 public:
  virtual ~IOManager() = default;

  virtual fml::WeakPtr<IOManager> GetWeakIOManager() const = 0;

  virtual fml::WeakPtr<GrContext> GetResourceContext() const = 0;

  virtual fml::RefPtr<flutter::SkiaUnrefQueue> GetSkiaUnrefQueue() const = 0;
};

}  // namespace flutter

#endif  // FLUTTER_LIB_UI_IO_MANAGER_H_
