# ft_flutter

#### 介绍
this repository provides glfw, skia modules for ft_engine

本模块基于OpenHarmony-3.2-Release，为方天显示引擎提供glfw，modules模块。

#### 源码编译
进入代码根目录，执行进行系统环境检查和依赖检查：./project_build/prebuild.sh。
完成依赖包的下载及安装后，直接运行 ./build.sh 即可开始构建。

#### 说明
编译完成后，会将skia/src/ports/skia_ohos/config/fontconfig.json配置文件拷贝到/etc/目录下。skia会从该文件获取字符库的安装目录，请将执行设备上的字符库安装目录补充在fontconfig.json配置文件中。
