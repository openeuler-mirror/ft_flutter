# Copyright (c) 2023 Huawei Technologies Co., Ltd. All rights reserved.
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

# =============================================================================
# Python
# =============================================================================
#
# check python3 in current system.
PYTHON_REQUIRED_VERSION="3.9.2"

echo -e "\e[36m[-] Prepare python3 packages...\e[0m"

# Check if python3 is installed
if ! command -v python3 &> /dev/null; then
    echo "python3 is not installed"
    exit 1
fi
if ! command -v pip3 &> /dev/null; then
    echo "pip3 is not installed"
    exit 1
fi
if ! command -v python &> /dev/null; then
    echo "python is not installed"
    sudo yum install python -y
fi

# Check python version
PYTHON_VERSION=$(python3 --version 2>&1 | awk '{print $2}')

# Compare the versions
if [ "$(printf '%s\n' "$PYTHON_REQUIRED_VERSION" "$PYTHON_VERSION" | sort -V | head -n1)" = "$PYTHON_REQUIRED_VERSION" ]; then
    echo "The python3 version is $PYTHON_VERSION"
else
    echo "The python3 version is less than $PYTHON_REQUIRED_VERSION"
fi

# Install python packages
SCRIPT_DIR=$(cd $(dirname $0);pwd)
PROJECT_DIR=$(dirname ${SCRIPT_DIR})

pip3 install -r ${SCRIPT_DIR}/configs/requirements.txt

# =============================================================================
# System Packages
# =============================================================================
#
# check system packages in current system by calling builder.py

echo -e "\e[36m[-] Prepare system packages...\e[0m"

# Check & Install required system packages
python3 ${PROJECT_DIR}/project_build/builder.py check --install-packages

# =============================================================================
# Prebuild
# =============================================================================
#
# download prebuild files
cd $home
PREBUILD_DIR="ft_prebuild"
if [ ! -d ${PREBUILD_DIR} ]; then
mkdir ${PREBUILD_DIR}
fi
cd ${PREBUILD_DIR}
FT_PREBUILD_DIR=$(pwd)

ARCHNAME=`uname -m`

# install ft_surface_wrapper
if [ ! -d ${FT_PREBUILD_DIR}/rpm/ft_surface_wrapper ]; then
    git clone https://gitee.com/ShaoboFeng/ft_surface_wrapper.git ${FT_PREBUILD_DIR}/rpm/ft_surface_wrapper
fi
cd ${FT_PREBUILD_DIR}/rpm/ft_surface_wrapper/
if [ ! -d ${FT_PREBUILD_DIR}/rpm/ft_surface_wrapper/build ]; then
    mkdir build
fi
cd build
cmake ..
make -j6
sudo make install
cd ${PROJECT_DIR}

# install mesa_fangtian
if [ ! -d ${FT_PREBUILD_DIR}/rpm/binary ]; then
    git clone https://gitee.com/huangyuxin2023/rpm-fangtian.git ${FT_PREBUILD_DIR}/rpm/binary
fi
cd ${FT_PREBUILD_DIR}/rpm/binary
./install.sh
cd ${PROJECT_DIR}

# copy flutter include files to /usr/local/include.
sudo mkdir -p /usr/local/include/flutter/txt
sudo cp -fr engine/flutter/third_party/txt/src/txt/asset_font_manager.h /usr/local/include/flutter/txt
sudo cp -fr engine/flutter/third_party/txt/src/txt/font_asset_provider.h /usr/local/include/flutter/txt
sudo cp -fr engine/flutter/third_party/txt/src/txt/font_collection.h /usr/local/include/flutter/txt
sudo cp -fr engine/flutter/third_party/txt/src/txt/font_features.h /usr/local/include/flutter/txt
sudo cp -fr engine/flutter/third_party/txt/src/txt/font_skia.h /usr/local/include/flutter/txt
sudo cp -fr engine/flutter/third_party/txt/src/txt/font_style.h /usr/local/include/flutter/txt
sudo cp -fr engine/flutter/third_party/txt/src/txt/font_weight.h /usr/local/include/flutter/txt
sudo cp -fr engine/flutter/third_party/txt/src/txt/paint_record.h /usr/local/include/flutter/txt
sudo cp -fr engine/flutter/third_party/txt/src/txt/paragraph_builder.h /usr/local/include/flutter/txt
sudo cp -fr engine/flutter/third_party/txt/src/txt/paragraph_builder_txt.h /usr/local/include/flutter/txt
sudo cp -fr engine/flutter/third_party/txt/src/txt/paragraph.h /usr/local/include/flutter/txt
sudo cp -fr engine/flutter/third_party/txt/src/txt/paragraph_style.h /usr/local/include/flutter/txt
sudo cp -fr engine/flutter/third_party/txt/src/txt/paragraph_txt.h /usr/local/include/flutter/txt
sudo cp -fr engine/flutter/third_party/txt/src/txt/placeholder_run.h /usr/local/include/flutter/txt
sudo cp -fr engine/flutter/third_party/txt/src/txt/platform.h /usr/local/include/flutter/txt
sudo cp -fr engine/flutter/third_party/txt/src/txt/styled_runs.h /usr/local/include/flutter/txt
sudo cp -fr engine/flutter/third_party/txt/src/txt/test_font_manager.h /usr/local/include/flutter/txt
sudo cp -fr engine/flutter/third_party/txt/src/txt/text_baseline.h /usr/local/include/flutter/txt
sudo cp -fr engine/flutter/third_party/txt/src/txt/text_decoration.h /usr/local/include/flutter/txt
sudo cp -fr engine/flutter/third_party/txt/src/txt/text_shadow.h /usr/local/include/flutter/txt
sudo cp -fr engine/flutter/third_party/txt/src/txt/text_style.h /usr/local/include/flutter/txt
sudo cp -fr engine/flutter/third_party/txt/src/txt/typeface_font_asset_provider.h /usr/local/include/flutter/txt

sudo mkdir -p /usr/local/include/flutter/txt/utils
sudo cp -fr engine/flutter/third_party/txt/src/utils/JenkinsHash.h /usr/local/include/flutter/txt/utils
sudo cp -fr engine/flutter/third_party/txt/src/utils/LruCache.h /usr/local/include/flutter/txt/utils
sudo cp -fr engine/flutter/third_party/txt/src/utils/TypeHelpers.h /usr/local/include/flutter/txt/utils
sudo cp -fr engine/flutter/third_party/txt/src/utils/WindowsUtils.h /usr/local/include/flutter/txt/utils

sudo mkdir -p /usr/local/include/flutter/txt/minikin
sudo cp -fr engine/flutter/third_party/txt/src/minikin/CmapCoverage.h /usr/local/include/flutter/txt/minikin
sudo cp -fr engine/flutter/third_party/txt/src/minikin/Emoji.h /usr/local/include/flutter/txt/minikin
sudo cp -fr engine/flutter/third_party/txt/src/minikin/FontCollection.h /usr/local/include/flutter/txt/minikin
sudo cp -fr engine/flutter/third_party/txt/src/minikin/FontFamily.h /usr/local/include/flutter/txt/minikin
sudo cp -fr engine/flutter/third_party/txt/src/minikin/FontLanguage.h /usr/local/include/flutter/txt/minikin
sudo cp -fr engine/flutter/third_party/txt/src/minikin/FontLanguageListCache.h /usr/local/include/flutter/txt/minikin
sudo cp -fr engine/flutter/third_party/txt/src/minikin/FontUtils.h /usr/local/include/flutter/txt/minikin
sudo cp -fr engine/flutter/third_party/txt/src/minikin/GraphemeBreak.h /usr/local/include/flutter/txt/minikin
sudo cp -fr engine/flutter/third_party/txt/src/minikin/HbFontCache.h /usr/local/include/flutter/txt/minikin
sudo cp -fr engine/flutter/third_party/txt/src/minikin/Hyphenator.h /usr/local/include/flutter/txt/minikin
sudo cp -fr engine/flutter/third_party/txt/src/minikin/Layout.h /usr/local/include/flutter/txt/minikin
sudo cp -fr engine/flutter/third_party/txt/src/minikin/LayoutUtils.h /usr/local/include/flutter/txt/minikin
sudo cp -fr engine/flutter/third_party/txt/src/minikin/LineBreaker.h /usr/local/include/flutter/txt/minikin
sudo cp -fr engine/flutter/third_party/txt/src/minikin/Measurement.h /usr/local/include/flutter/txt/minikin
sudo cp -fr engine/flutter/third_party/txt/src/minikin/MinikinFont.h /usr/local/include/flutter/txt/minikin
sudo cp -fr engine/flutter/third_party/txt/src/minikin/MinikinInternal.h /usr/local/include/flutter/txt/minikin
sudo cp -fr engine/flutter/third_party/txt/src/minikin/SparseBitSet.h /usr/local/include/flutter/txt/minikin
sudo cp -fr engine/flutter/third_party/txt/src/minikin/WordBreaker.h /usr/local/include/flutter/txt/minikin

sudo mkdir -p /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/base32.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/build_config.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/closure.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/command_line.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/compiler_specific.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/concurrent_message_loop.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/delayed_task.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/eintr_wrapper.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/file.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/gpu_thread_merger.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/icu_util.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/logging.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/log_level.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/log_settings.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/macros.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/make_copyable.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/mapping.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/message.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/message_loop.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/message_loop_impl.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/message_loop_task_queues.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/native_library.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/paths.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/size.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/status.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/task_runner.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/thread.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/thread_local.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/trace_event.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/unique_fd.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/unique_object.h /usr/local/include/flutter/fml
sudo cp -fr engine/flutter/fml/wakeable.h /usr/local/include/flutter/fml

sudo mkdir -p /usr/local/include/flutter/fml/memory
sudo cp -fr engine/flutter/fml/memory/ref_counted.h /usr/local/include/flutter/fml/memory
sudo cp -fr engine/flutter/fml/memory/ref_counted_internal.h /usr/local/include/flutter/fml/memory
sudo cp -fr engine/flutter/fml/memory/ref_ptr.h /usr/local/include/flutter/fml/memory
sudo cp -fr engine/flutter/fml/memory/ref_ptr_internal.h /usr/local/include/flutter/fml/memory
sudo cp -fr engine/flutter/fml/memory/thread_checker.h /usr/local/include/flutter/fml/memory
sudo cp -fr engine/flutter/fml/memory/weak_ptr.h /usr/local/include/flutter/fml/memory
sudo cp -fr engine/flutter/fml/memory/weak_ptr_internal.h /usr/local/include/flutter/fml/memory

echo -e "\033[32m[*] Pre-build Done. You need exec 'build.sh'.\033[0m"
