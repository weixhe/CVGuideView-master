# CVGuideView-master

这里总结一下app需要用到的引导页，题外话：不推荐直接使用ViewController，原因如下：
1. 使用ViewController可以直接设置window的rootViewController，这是如果浏览结束，只能重新设置rootViewController的首页，过渡太生硬
2.  如果不设置rootViewController，直接present出首页，平时没什么问题，但是如果有一个model页面需要dismiss到root时就会暴露，这是一个坑
3.  将引导页设置到首页中，然后app首次启动的时候直接present出来，这时会有一个首页的闪现，体现不好

所以，推荐大家直接使用view，然后add在window上，注意层级关系，一定要在设置好rootViewController并调用`makeKeyAndVisible() `后再进行添加


版本：1.0

开发语言版本：swift 4

###### 控件一：视觉差引导页 `CVParallaxGuideView`
使用方法如下：
```
self.window = UIWindow(frame: UIScreen.main.bounds)
self.window!.backgroundColor = UIColor.white
self.window!.rootViewController = ViewController()
self.window!.makeKeyAndVisible()

let guideView = CVParallaxGuideView(titles: titles, contents: contents, backgroundImage: srcImage)
guideView.show(in: self.window!, scrollDirection: .horizontal)
```

![image](https://github.com/weixhe/CVGuideView-master/blob/master/CVGuideView/ParallaxGuide.gif)
