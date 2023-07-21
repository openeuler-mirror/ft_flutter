// Copyright 2013 The Flutter Authors. All rights reserved.
// Copyright (c) Huawei Technologies Co., Ltd. 2021. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
// 2021.2.10 Increase the process used in native_view mode.
//           Copyright (c) 2021 Huawei Device Co., Ltd. All rights reserved.

#ifndef FLUTTER_FLOW_OHOS_LAYERS_CLIP_RRECT_LAYER_H
#define FLUTTER_FLOW_OHOS_LAYERS_CLIP_RRECT_LAYER_H

#include "include/core/SkRRect.h"

#include "flutter/flow/ohos_layers/container_layer.h"
#include "flutter/flow/ohos_layers/layer.h"

namespace flutter::OHOS {

class ClipRRectLayer : public ContainerLayer {
public:
    ClipRRectLayer(const SkRRect& clipRrect, Clip clipBehavior)
        : clipRrect_(clipRrect), clipBehavior_(clipBehavior) {}
    ~ClipRRectLayer() override = default;

    void Prepare(const SkMatrix& matrix) override;

    void Paint(const PaintContext& paintContext) const override;

private:
    SkRRect clipRrect_;
    Clip clipBehavior_;

    FML_DISALLOW_COPY_AND_ASSIGN(ClipRRectLayer);
};

}  // namespace flutter::OHOS

#endif  // FLUTTER_FLOW_OHOS_LAYERS_CLIP_RRECT_LAYER_H