
;(function() {
	if (window.SESDK) { return }
	
	function connectWebViewJavascriptBridge(callback) {
		if (window.WebViewJavascriptBridge) {
			callback(WebViewJavascriptBridge)
		} else {
			document.addEventListener('WebViewJavascriptBridgeReady', function() {
				callback(WebViewJavascriptBridge)
			}, false)
		}
	}

	function initBridge(complete) {
		connectWebViewJavascriptBridge(function(bridge) {
			function log(message, data) {
				if (typeof console != 'undefined') {
					console.log(message + ':' + JSON.stringify(data));
				}
			}
			bridge.init(function(message, responseCallback) {
				log('JS got a message', message)
				var data = { 'Javascript Responds':'Wee!' }
				log('JS responding with', data)
				responseCallback(data)
			})
			complete();
		})
	}

	function invoke(name, args, complete) {
		WebViewJavascriptBridge.callHandler(name, args, complete);
	}

	function registerCallback(name, callback) {
		WebViewJavascriptBridge.registerHandler(name, function(data, responseCallback) {
			callback(data);
		});
	}

	// 创建SESDK对象
	window.SESDK = {
        onAppDidEnterBackground: function(callback) {
            registerCallback('onAppDidEnterBackground', callback)
        },
        onAppDidBecomeActive: function(callback) {
            registerCallback('onAppDidBecomeActive', callback)
        },
        alert: function(arg) {
            invoke('alert', arg, null);
        },
        playAudioWithURL: function(arg) {
            invoke('playAudioWithURL', arg, null);
        },
        stopAudioWithURL: function(arg) {
            invoke('stopAudioWithURL', arg, null);
        },
        stopAllAudio: function() {
            invoke('stopAllAudio', null, null);
        },
        getDeviceDiskInfo: function(complete) {
            invoke('getDeviceDiskInfo', null, complete);
        },
		setNavigationRightBarButton: function(arg, onClick) {
			registerCallback('onNavigationRightBarButtonClick', onClick);
			invoke('setNavigationRightBarButton', arg, null);
		},
		setTitle:  function(arg) {
			invoke('setTitle', arg, null);
		},
        exit: function() {
            invoke('exit', null, null);
        },
        getNetworkStatus: function(complete) {
            invoke('getNetworkStatus', null, complete);
        },
		canOpenURL: function(arg, complete) {
			invoke('canOpenURL', arg, complete);
		},
		openURL: function(arg, complete) {
			invoke('openURL', arg, complete);
		},
		onPlayAudioEnd: function(callback) {
            registerCallback('onPlayAudioEnd', callback);
        },
        writeImageToAlbum: function(arg, complete) {
            invoke('writeImageToAlbum', arg, complete);
        },
        getBatteryState: function(complete) {
            invoke('getBatteryState', null, complete);
        },
        getAssetsAuthStatus: function(complete) {
            invoke('getAssetsAuthStatus', null, complete);
        },
        getCalendarAuthStatus: function(complete) {
            invoke('getCalendarAuthStatus', null, complete);
        },
        getBeaconList: function(complete) {
            invoke('getBeaconList', null, complete);
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
})();
