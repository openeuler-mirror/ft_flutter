// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef FLUTTER_LIB_UI_PAINTING_MATRIX_H_
#define FLUTTER_LIB_UI_PAINTING_MATRIX_H_

#include "flutter/lib/ui/dart_wrapper.h"
#include "include/core/SkMatrix.h"

namespace flutter {

SkMatrix ToSkMatrix(const tonic::Float64List& matrix4);


}  // namespace flutter

#endif  // FLUTTER_LIB_UI_PAINTING_MATRIX_H_
