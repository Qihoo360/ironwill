iOS-JSSDK
=======================
iOS平台上可复用的JSSDK，可供WebView中的JS调用。
通过此SDK可以增强JS的能力，使得JS能够具有App的Native功能（如：获取空间信息、获取网络状态、获取电池状态、访问相册、扫描Beacon等）。
此SDK的目的是提供一个基础功能的JSSDK，开发者可以直接使用这些基本功能，同时也可以在此基础上扩展出其他个性化的功能。

Requirement
===========
iOS6+

如何使用
=======================
JSSDK的使用需要App端和JavaScript端，两端相互配合。在两端都需要添加相应代码。
App端
---------------------------------

1) 引入头文件
```objc
#import "SEJavaScriptSDK.h"
```

2) ViewController中添加SDK成员变量
```objc
@interface ViewController () <UIWebViewDelegate> {
    // ...
    SEJavaScriptSDK * _jsSDK;
}
```

3) 初始化SDK
```objc
- (void)viewDidLoad {
    [super viewDidLoad];

    _jsSDK = [SEJavaScriptSDK SDKWithBuilder:[SEJavaScriptSDKBuilder class] block:^(SEJavaScriptSDKBuilder *builder) {
        builder.setTitleDelegate = self;
        builder.exitDelegate = self;
        builder.setNavigationRightBarButtonDelegate = self;
        builder.webView = _webView;
        builder.webViewDelegate = self;
        builder.bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"SEJSSDKResource" withExtension:@"bundle"]];
    }];
    
    // Load HTML WebPage
    // ...
}
```

4) 实现回调
```objc
#pragma mark - SEJSMethodSetNavigationRightBarButtonDelegate
- (void)onJSMethodSetNavigationRightBarButton:(NSString *)title {
    if ([title isKindOfClass:[NSString class]] && title.length > 0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(onClickNavigationRightBarButton)];
    } else {
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)onClickNavigationRightBarButton {
    [_jsSDK onNavigationRightBarButtonClick];
}

#pragma mark - SEJSMethodSetTitleDelegate
- (void)onJSMethodSetTitle:(NSString *)title {
    self.title = title;
}

#pragma mark - SEJSMethodExitDelegate
- (void)onJSMethodExit
{
    if (self.navigationController) {
        // push
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        // present
        [self dismissViewControllerAnimated:YES completion:^{
            // do nothing;
        }];
    }
}
```

JavaScript端
---------------------------------
```javascript
function sdkReady() {
        document.removeEventListener('SEJSSDKReady', sdkReady, false);
        
        // 设置ViewController的标题
        SESDK.setTitle({title:'标题'});
        
        //右上角设置［分享］按钮
        SESDK.setNavigationRightBarButton({
                                          title:'分享'
                                          },
                                          function (res) {
                                            // 分享按钮点击处理函数
                                            alert("分享按钮被点击");
                                          })
}
if (typeof window.SESDK != 'undefined') {
    // SESDK已经初始化，可直接使用，无需等事件
    sdkReady();
}
else {
    // SESDK未初始化完毕，必须等收到SEJSSDKReady事件后，才可以使用SESDK对象
    document.addEventListener('SEJSSDKReady', sdkReady, false);
}
```

API 接口说明
============

setTitle
----------------------
设置ViewController标题
```javascript
SESDK.setTitle({title:'标题'});
```

setNavigationRightBarButton
------------------
设置标题栏右侧按钮
```javascript
SESDK.setNavigationRightBarButton({
    title:'分享'
}, function (res) {
    // 按钮点击处理函数
});
```

exit
-----
关闭ViewController
```javascript
SESDK.exit()
```

canOpenURL
----------
判断URLScheme是否能打开
```javascript
SESDK.canOpenURL({
    'http://www.so.com'
}, function (result) {
    if (result) {
    	// 能打开URL
    } else {
    	// 不能打开URL
    }
});
```

openURL
------------------
打开URLScheme
```javascript
SESDK.openURL({
    'http://www.so.com'
}, function (result) {
    if (result) {
	    // 打开URL成功
    } else {
	    // 打开URL失败
    }
})
```

getNetworkStatus
------------------
获取设备当前网络状态
```javascript
SESDK.getNetworkStatus(function (res) {
    if (res.networkType == 0) {
		// 无网络
	} else if (res.networkType == 1) {
		// Wi-Fi网络
	} else if (res.networkType > 1 && res.networkType < 10) {
		// 蜂窝网络
        // 2: 2G
        // 3: 3G
        // 4: 4G
        // 9: 蜂窝网络但无法识别具体类型
	} else {
		// 未识别网络类型
	}
})
```

getDeviceDiskInfo
------------------
获取设备当前磁盘信息
```javascript
SESDK.getDeviceDiskInfo(function (res) {
    //设备磁盘的总字节数
	var total = res.totalBytes
	//设备当前可用磁盘的字节数
	var available = res.availableBytes
})
```

playAudioWithURL
------------------
播放在线音频
```javascript
SESDK.playAudioWithURL({
    'url': 'http://www.so.com/1.mp3',
	'loops': 0
})
```
#### 注意
播放结束时，会触发onPlayAudioEnd事件

stopAudioWithURL
------------------
停止播放某在线音频
```javascript
SESDK.stopAudioWithURL({
    'url': 'http://www.so.com/1.mp3'
})
```
#### 注意
通过这种方式结束音频播放，不会触发onPlayAudioEnd事件

stopAllAudio
------------------
停止所有音频
```javascript
SESDK.stopAllAudio()
```
#### 注意
通过这种方式结束音频播放，不会触发onPlayAudioEnd事件

onPlayAudioEnd [事件]
------------------
当播放自动结束时，会触发该事件
```javascript
SESDK.onPlayAudioEnd(function (response) {
    var url = response.url
	// TODO: url对应的音频已播放结束
})
```

alert
------------------
弹出iOS原生UIAlertView
```javascript
SESDK.alert({
    'title': '提示',					//标题
	'msg': '当前网络为3G',			//文本
	'cancel_title': '我知道了'			//取消按钮的标题
})
```

onAppDidEnterBackground [事件]
------------------
当程序切后台后，会触发该事件
```javascript
SESDK.onAppDidEnterBackground(function () {
    // TODO: 程序切后台之后要做的事
})
```

onAppDidBecomeActive [事件]
------------------
当程序切前台后（准确地说，是当App前台激活），会触发该事件
```javascript
SESDK.onAppDidBecomeActive(function () {
    // TODO: 程序切前台之后要做的事
})
```

writeImageToAlbum
------------------
保存照片到系统相册
```javascript
SESDK. writeImageToAlbum ({
    'data': ' data:image/gif;base64,AAAA==', // DataURL格式
	'album': '360手机卫士壁纸'
}, function (res) {
	if (res.error == 0) {
		//TODO: 保存成功
	} else {
		//TODO: 保存失败
       alert(res.error);
	}
})
```

getBatteryState
------------------
获取电池状态
```javascript
SESDK. getBatteryState (
function (res) {
    // …
	alert(‘state’ + res.state);
	alert(‘level’ + res.level);
})
```

getAssetsAuthStatus
-------------------
获取相册权限状态
```javascript
SESDK. getAssetsAuthStatus (
function (status) {
    // 0: 未授权(NotDetermined)
    // 1: 未授权(Restricted)
    // 2: 未授权(Denied)
    // 3: 已授权(Authorized)
	alert(‘status’ + status);
})
```

getCalendarAuthStatus
-------------------
获取日历权限状态
```javascript
SESDK. getCalendarAuthStatus (
function (status) {
    // 0: 未授权(NotDetermined)
    // 1: 未授权(Restricted)
    // 2: 未授权(Denied)
    // 3: 已授权(Authorized)
	alert(‘status’ + status);
})
```

getBeaconList
-------------------
获取周边Beacon信息
```javascript
SESDK. getBeaconList (
function (res) {
    alert(‘res:’ + JSON. stringify(res));
})
```

如何扩展
=======================
假设需要扩展的JS接口为退出App：接口名为exitApp。

App端
---------------------------------
1) 实现一个类：JSMethodExitApp，继承SEJSMethod，实现getName和invoke方法；
```objc
// SEJSMethodExitApp.h文件
@interface SEJSMethodExitApp : SEJSMethod

@end

// SEJSMethodExitApp.m文件
@implementation SEJSMethodExitApp

// 返回接口名
- (NSString *)getName
{
    return @"exitApp";
}

// 执行接口
- (id)invoke:(id)args
{
    // 结束进程
    exit(0);
    
    return nil;
}

@end
```

2) 实现一个类：MyJSSDKBuilder，继承SEJavaScriptSDKBuilder，实现buildMethods方法；
```objc
- (void)buildMethods:(NSMutableArray *)methods {
    [super buildMethods:methods];
    
    // exitApp
    {
        SEJSMethodExitApp *method = [[SEJSMethodExitApp alloc] init];
        [methods addObject:method];
    }
}
```

3) ViewController中使用MyJSSDKBuilder初始化SDK；
```objc
- (void)viewDidLoad {
    [super viewDidLoad];

    _jsSDK = [SEJavaScriptSDK SDKWithBuilder:[MyJSSDKBuilder class] block:^(SEJavaScriptSDKBuilder *builder) {
        builder.setTitleDelegate = self;
        builder.exitDelegate = self;
        builder.setNavigationRightBarButtonDelegate = self;
        builder.webView = _webView;
        builder.webViewDelegate = self;
        builder.bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"SEJSSDKResource" withExtension:@"bundle"]];
    }];
    
    // Load HTML WebPage
    // ...
}
```

JavaScript端
---------------------------------
1) SEJSBridge.js中，init方法前，添加接口映射
```javascript
    // 创建SESDK对象
    window.SESDK = {
        // ...
        
        // exitApp
        exitApp: function() {
            invoke('exitApp', null, null);
        },
        
        init: function () {
            initBridge(function(){
                // 初始化完成，发送Read事件
                var readyEvent = document.createEvent('Events')
                readyEvent.initEvent('SEJSSDKReady')
                document.dispatchEvent(readyEvent)
            })
        }
	}
```

2) JavaScript中调用这个接口
```javascript
    // JavaScript代码
    SESDK.exitApp();
```