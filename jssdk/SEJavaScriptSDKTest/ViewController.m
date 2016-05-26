//
//  ViewController.m
//  SEJavaScriptSDKTest
//
//  Created by aizhongyuan on 15/3/3.
//  Copyright (c) 2015年 aizhongyuan. All rights reserved.
//

#import "ViewController.h"

#import "SEJavaScriptSDK.h"
#import "SEJSMethodCanOpenURL.h"
#import "SEJSMethodOpenURL.h"
#import "SEJSMethodExit.h"
#import "SEJSMethodSetNavigationRightBarButton.h"
#import "SEJSMethodSetTitle.h"

@interface ViewController () <UIWebViewDelegate, SEJSMethodExitDelegate, SEJSMethodSetTitleDelegate, SEJSMethodSetNavigationRightBarButtonDelegate>
@end

@implementation ViewController {
    SEJavaScriptSDK * _jsSDK;
    
    IBOutlet UIWebView * _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    _jsSDK = [SEJavaScriptSDK SDKWithBuilder:[SEJavaScriptSDKBuilder class] block:^(SEJavaScriptSDKBuilder *builder) {
        builder.setTitleDelegate = self;
        builder.exitDelegate = self;
        builder.setNavigationRightBarButtonDelegate = self;
        builder.webView = _webView;
        builder.webViewDelegate = self;
        builder.bundle = [NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:@"SEJSSDKResource" withExtension:@"bundle"]];
    }];
    
    
    
    [self loadExamplePage:_webView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadExamplePage:(UIWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
    
//    NSString * strUrl = @"http://huodong.ios.shouji.360.cn/walls/index.html";
//    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
//    [webView loadRequest:request];
}

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

#pragma mark - UIWebViewDelegate

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
//{
//    
//}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"%s %@", __PRETTY_FUNCTION__, error);
}

@end
