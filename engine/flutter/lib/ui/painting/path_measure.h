// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#ifndef FLUTTER_LIB_UI_PAINTING_PATH_MEASURE_H_
#define FLUTTER_LIB_UI_PAINTING_PATH_MEASURE_H_

#include <vector>

#include "flutter/lib/ui/dart_wrapper.h"
#include "flutter/lib/ui/painting/path.h"
#include "include/core/SkContourMeasure.h"
#include "include/core/SkPath.h"

namespace tonic {
class DartLibraryNatives;
}  // namespace tonic

// Be sure that the client doesn't modify a path on us before Skia finishes
// See AOSP's reasoning in PathMeasure.cpp

namespace flutter {

class CanvasPathMeasure : public RefCountedDartWrappable<CanvasPathMeasure> {
  DEFINE_WRAPPERTYPEINFO();
  FML_FRIEND_MAKE_REF_COUNTED(CanvasPathMeasure);

 public:
  ~CanvasPathMeasure() override;
  static fml::RefPtr<CanvasPathMeasure> Create(const CanvasPath* path,
                                               bool forceClosed);

  void setPath(const CanvasPath* path, bool isClosed);
  float getLength(int contourIndex);
  tonic::Float32List getPosTan(int contourIndex, float distance);
  fml::RefPtr<CanvasPath> getSegment(int contourIndex,
                                     float startD,
                                     float stopD,
                                     bool startWithMoveTo);
  bool isClosed(int contourIndex);
  bool nextContour();

  static void RegisterNatives(tonic::DartLibraryNatives* natives);

  const SkContourMeasureIter& pathMeasure() const { return *path_measure_; }

 private:
  CanvasPathMeasure();

  std::unique_ptr<SkContourMeasureIter> path_measure_;
  std::vector<sk_sp<SkContourMeasure>> measures_;
};

}  // namespace flutter

#endif  // FLUTTER_LIB_UI_PAINTING_PATH_MEASURE_H_
