// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#include "flutter/flow/compositor_context.h"

#include "flutter/flow/layers/layer_tree.h"
#include "include/core/SkCanvas.h"

namespace flutter {

CompositorContext::CompositorContext() = default;

CompositorContext::~CompositorContext() = default;

void CompositorContext::BeginFrame(ScopedFrame& frame,
                                   bool enable_instrumentation) {
  if (enable_instrumentation) {
    frame_count_.Increment();
    raster_time_.Start();
  }
}

void CompositorContext::EndFrame(ScopedFrame& frame,
                                 bool enable_instrumentation) {
  raster_cache_.SweepAfterFrame();
  if (enable_instrumentation) {
    raster_time_.Stop();
  }
}

std::unique_ptr<CompositorContext::ScopedFrame> CompositorContext::AcquireFrame(
    GrContext* gr_context,
    SkCanvas* canvas,
    ExternalViewEmbedder* view_embedder,
    const SkMatrix& root_surface_transformation,
    bool instrumentation_enabled,
    fml::RefPtr<fml::GpuThreadMerger> gpu_thread_merger) {
  return std::make_unique<ScopedFrame>(
      *this, gr_context, canvas, view_embedder, root_surface_transformation,
      instrumentation_enabled, gpu_thread_merger);
}

CompositorContext::ScopedFrame::ScopedFrame(
    CompositorContext& context,
    GrContext* gr_context,
    SkCanvas* canvas,
    ExternalViewEmbedder* view_embedder,
    const SkMatrix& root_surface_transformation,
    bool instrumentation_enabled,
    fml::RefPtr<fml::GpuThreadMerger> gpu_thread_merger)
    : context_(context),
      gr_context_(gr_context),
      canvas_(canvas),
      view_embedder_(view_embedder),
      root_surface_transformation_(root_surface_transformation),
      instrumentation_enabled_(instrumentation_enabled),
      gpu_thread_merger_(gpu_thread_merger) {
  context_.BeginFrame(*this, instrumentation_enabled_);
}

CompositorContext::ScopedFrame::~ScopedFrame() {
  context_.EndFrame(*this, instrumentation_enabled_);
}

RasterStatus CompositorContext::ScopedFrame::Raster(
    flutter::LayerTree& layer_tree,
    bool ignore_raster_cache) {
  layer_tree.Preroll(*this, ignore_raster_cache);
  PostPrerollResult post_preroll_result = PostPrerollResult::kSuccess;
  if (view_embedder_ && gpu_thread_merger_) {
    post_preroll_result = view_embedder_->PostPrerollAction(gpu_thread_merger_);
  }

  if (post_preroll_result == PostPrerollResult::kResubmitFrame) {
    return RasterStatus::kResubmit;
  }
  // Clearing canvas after preroll reduces one render target switch when preroll
  // paints some raster cache.
  if (canvas()) {
    canvas()->clear(SK_ColorTRANSPARENT);
  }
  layer_tree.Paint(*this, ignore_raster_cache);
  return RasterStatus::kSuccess;
}

void CompositorContext::OnGrContextCreated() {
  texture_registry_.OnGrContextCreated();
  raster_cache_.Clear();
}

void CompositorContext::OnGrContextDestroyed() {
  texture_registry_.OnGrContextDestroyed();
  raster_cache_.Clear();
}

}  // namespace flutter
