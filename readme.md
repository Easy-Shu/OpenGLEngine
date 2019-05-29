# 基于OpenGL实现的渲染引擎

在mac上实现了一套渲染引擎，后期会扩展到移动平台

我们在Qt环境下，使用相同的代码实现了相同的效果， [点击前往](https://github.com/huailiang/qt_engine), 可能这样会更适合你做编辑器扩展。

# 依赖的库
*  openGL
*  glad
* grewf
* freetype
* glm


# 特征


## 1. 光照系统

目前支持三种光照

- 聚光灯 

黑暗交替自然过渡， 且光照强度随着距离变远而衰减

<br><img src='image/spot.jpg'> <br>
 
- 点光源

光照强度随着距离变远而衰减

<br><img src='image/point.jpg'> <br>

- 平行光

<br><img src='image/direct.jpg'> <br>


## 2. 控制系统

- 实现 WASD 按键来前后左右移动相机

- 按住Space键绕前方定点旋转相机

- 按上下左右键来改变场景里的光的方向


## 3. GUI

<br><img src='image/avatar.jpg'> <br>


初步实现了显示TrueType字体

点击事件系统

ui可以画Label, Button

## 4. Shadow 阴影

<br><img src='image/shadow.jpg'> <br>

右下角即灯光空间的depth-buffer


## 5. 更多就不枚举了

比如使用GPU Instance 批量画草， geomotry Shader显示法线，变换帧缓存后处理， PBR、BRDF、 IBL 更多的功能等你去探索

后期会逐步扩展引擎， 比如AR模块、lua热更模块、编写更多的geomotry以便调试

# 语法

## 1. glsl中支持文件包含

默认的glsl羽凡是不支持#include的， 我们这里实现了预编译扩展的效果， 使用如下：

```c
#include "lib/brdf.glsl"
```

注意include的路径是相对于shader目录的路径，而不是当前shader所在的路径

## 2. 运行时切换宏

你可以在glsl使用#ifdef类似c的语法这样定义

```c
#ifdef _CALLBACK__ 
for(int i=0;i<LIGHT_NUM;i++)
{
   [...]
}
#else
[...]
#endif
```

在c++中在shader运行时编译前，这样设置对glsl的宏

```cpp
Shader("model.vs","outline.fs",nullptr, Macro("_CALLBACK__","","LIGHT_NUM","4")
```

## 3.Debug支持

 如果shader报错，会显示对应的行号，你可以去temp目录查看预编译好的shader， 迅速定位到问题。

注意：	只有在DEBUG模式下， 才会生成预编译的shader， Release下为了效率是不生成预编译的shder的。



<br>
penghuailiang<br>
2019-05-10
