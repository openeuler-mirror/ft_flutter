// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef FLUTTER_LIB_UI_PAINTING_CODEC_H_
#define FLUTTER_LIB_UI_PAINTING_CODEC_H_

#include "flutter/lib/ui/dart_wrapper.h"
#include "flutter/lib/ui/painting/frame_info.h"
#include "include/codec/SkCodec.h"
#include "include/core/SkBitmap.h"
#include "include/core/SkImage.h"

using tonic::DartPersistentValue;

namespace tonic {
class DartLibraryNatives;
}  // namespace tonic

namespace flutter {

// A handle to an SkCodec object.
//
// Doesn't mirror SkCodec's API but provides a simple sequential access API.
class Codec : public RefCountedDartWrappable<Codec> {
  DEFINE_WRAPPERTYPEINFO();

 public:
  virtual int frameCount() const = 0;

  virtual int repetitionCount() const = 0;

  virtual Dart_Handle getNextFrame(Dart_Handle callback_handle) = 0;

  void dispose();

  static void RegisterNatives(tonic::DartLibraryNatives* natives);
};

}  // namespace flutter

#endif  // FLUTTER_LIB_UI_PAINTING_CODEC_H_
