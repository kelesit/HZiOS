title: iOS篇之CocoaPods
date: 2015-01-05  
categories: iOS 
tags: [iOS工具]
---
  
### CocoaPods 上手体验： 
  
>当开发环境已经具备CocoaPods功能，再次引入三方库，只需要在工程目录文件Podfile中添加 pod  ’Three party libraries Name’,’~>versionCode’ 然后 pod update ；项目就集成了你需要的三方库；再也不要去github上download到本地，手动拖入工程，配置各种framework，不是ARC的还要........
<!--more-->
### CocoaPods简介:  

> 关于CocoaPods的前世今生Mattt Thompson 的这篇[CocoaPods](http://nshipster.cn/cocoapods/)讲解的很清晰.

### CocoaPods安装：

+ CocoaPods：资料上说是用Ruby实现的，要想使用它首先需要有Ruby的环境。还好OSX系统默认的已经可以运行Ruby，再说gem，她是管理Ruby库和程序的标准包，所以查看一下自己MAC 上的版本 


```
$ gem -v   #执行此命令获取版本信息
```  
不过还是建议直接升级（低版本的各种坑，会导致你一直会使用各家引擎搜索关于各种bug的解决方案)


```
$ sudo gem update --system #完成版本更新
```  
+ 直接安装CocoaPods运行终端命令（不建议执行该命令，原因往下看）

```
$ sudo gem install cocoapods #安装CocoaPods
```
手贱运行了OK等啊等啊没信了原因呵呵，解决方案（来自智慧的程序猿，具体改动了什么我也不知道）
```
$ gem sources--remove https://rubygems.org/ #等待有反应再敲下面的命令
```
```
$ gem sources -a https://ruby.taobao.org/ 
```
可以执行命令检测是否替换成功
```
$ gem sources -l 
```
成功信息
```
http://ruby.taobao.org/ #来自网络
```
+ 再次执行install命令

```
$ sudo gem install cocoapods #安装CocoaPods
```
*需要注意的是，如果安装的时候使用了sudo，升级的时候一样需要使用该关键字，不然升级完了以后又会出现路径不匹配问题。*
+ 安装进程结束后执行

```
$ pod setup
```

### CocoaPods的使用：
##### 据说CocoaPods的一切都是从一个名为Podfile的文件开始的，所以要有这样一个文件

+ 创建一个CocoaPodsTest项目放在桌面；终端运行（目录是本人pro的路径。具体操作看自己的工程路径）

```
$ cd /Users/apple/Desktop/CocoaPodsTest #切换到工程目录
```
```
$ touch Podfile #创建一个Podfile文件
```
+ 在Podfile文件中存放以下内容（可以使用vim直接编辑，vim使用本人也很菜）
  

> platform :ios, '7.0'  
pod 'AFNetworking', '~> 2.0'
  

+ 切换工程目录

```
$ cd /Users/apple/Desktop/CocoaPodsTest #切换到工程目录
```
```
$ pod install
```

+ 关闭xcode，打开CocoaPodsTest.xcworkspace文件 就会看到AFNetWorking
+ CocoaPods的添加新的三方库：
- 使用命令查找你需要的三方库信息（例如SBJson）

```
$ pod search SBJson #查看三方库信息
```
- 将执行获取的信息 {pod ’SBJson’,’~>4.0.1’}保存到 Podfile文件中
- 在当前目录执行

```
$ pod update #更新
```
- 如果不需要更新podspec,可以添加下面的参数 

```
   --no-repo-update
```

### CocoaPods的卸载：

```
   sudo gem uninstall cocoapods
```

[CocoaPods详解之——使用篇](http://blog.csdn.net/xdrt81y/article/details/30631221)
[CocoaPods详解之----进阶篇](http://blog.csdn.net/xdrt81y/article/details/30631595)
[CocoaPods详解之----制作篇](http://blog.csdn.net/xdrt81y/article/details/30632329)

#### 20160831更新 
##### 安装错误
安装时出现 ERROR:  While executing gem ... (Errno::EPERM)
    Operation not permitted - /usr/bin/xcodeproj  解决方法： sudo gem install -n /usr/local/bin cocoapods  使用此命令安装
    
##### The dependency `Aspects` is not used in any concrete target.解决
     target 'HZUIKIT' do
     pod 'Aspects'
     end 
#### 20160926更新  
> 错误信息 None of your spec sources contain a spec satisfying the dependency  

解决方式： pod setup --verbose 

#### 20181020更新  
 
>  /usr/local/bin/pod: bad interpreter: /System/Library/Frameworks/Ruby.framework/Versions/2.0/usr/bin: no such file or directory  

(1)sudo gem update -n /usr/local/bin --system  

>  ERROR:  While executing gem ... (Gem::RemoteFetcher::FetchError)bad response Not Found 404 (https://gems.ruby-china.org/specs.4.8.gz)  

+ gem sources --remove https://rubygems.org/
+ gem sources --remove https://ruby.taobao.org/ 
+ gem sources -a https://gems.ruby-china.com/
+ gem sources -l

>  Operation not permitted @ rb_sysopen - /System/Library/Frameworks/Ruby.framework/Versions/2.3/usr/bin/gem

  sudo gem install -n /usr/local/bin cocoapods   

 

