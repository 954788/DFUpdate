# DFUpdate
简单方便的更新提醒
简书地址:http://www.jianshu.com/p/d088a8f6ab48

使用方式：
把`DFUpdate.h` 和`DFUpdate.m`导入项目中，在需要检测更新的控制器的`viewDidAppear`方法中加入

```[[DFUpdate shareManager] checkUpdateWithShowNewContent:YES noMore:YES];```即可使用

`showNewContent`
负责控制是否显示更新的内容

`noMore`
负责控制是否使用不再显示的方式(忽略当前版本，当下一个新版本发布后，会提示更新)

