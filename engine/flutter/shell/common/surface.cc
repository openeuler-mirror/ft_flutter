// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "flutter/shell/common/surface.h"

#include "flutter/fml/logging.h"
#include "include/core/SkSurface.h"

namespace flutter {

SurfaceFrame::SurfaceFrame(sk_sp<SkSurface> surface,
                           SubmitCallback submit_callback)
    : submitted_(false), surface_(surface), submit_callback_(submit_callback) {
  FML_DCHECK(submit_callback_);
}

SurfaceFrame::~SurfaceFrame() {
  if (submit_callback_ && !submitted_) {
    // Dropping without a Submit.
    submit_callback_(*this, nullptr);
  }
}

bool SurfaceFrame::Submit() {
  if (submitted_) {
    return false;
  }

  submitted_ = PerformSubmit();

  return submitted_;
}

SkCanvas* SurfaceFrame::SkiaCanvas() {
  return surface_ != nullptr ? surface_->getCanvas() : nullptr;
}

sk_sp<SkSurface> SurfaceFrame::SkiaSurface() const {
  return surface_;
}

bool SurfaceFrame::PerformSubmit() {
  if (submit_callback_ == nullptr) {
    return false;
  }

  if (submit_callback_(*this, SkiaCanvas())) {
    return true;
  }

  return false;
}

Surface::Surface() = default;

Surface::~Surface() = default;

flutter::ExternalViewEmbedder* Surface::GetExternalViewEmbedder() {
  return nullptr;
}

bool Surface::MakeRenderContextCurrent() {
  return true;
}

}  // namespace flutter
