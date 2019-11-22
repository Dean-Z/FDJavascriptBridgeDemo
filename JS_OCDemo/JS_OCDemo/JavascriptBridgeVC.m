//
//  JavascriptBridgeVC.m
//  Demo_GCD
//
//  Created by Jason on 2019/11/17.
//  Copyright © 2019 Jason. All rights reserved.
//

#import "JavascriptBridgeVC.h"
#import "WebViewJavascriptBridge.h"
#import <WebKit/WebKit.h>

@interface JavascriptBridgeVC ()<WKNavigationDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property WebViewJavascriptBridge* bridge;
@property (nonatomic, strong) WKWebView *webView;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (nonatomic, assign) NSInteger index;

@end

@implementation JavascriptBridgeVC

- (UIImagePickerController *)picker
{
    if (!_picker) {
        _picker = [[UIImagePickerController alloc]init];
        _picker.delegate = self;
    }
    return _picker;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 68)];
    topView.backgroundColor = [UIColor systemBlueColor];
    [self.view addSubview:topView];
    
    UIButton *demoBtn = [UIButton new];
    [demoBtn setTitle:@"加一行文字" forState:UIControlStateNormal];
    demoBtn.frame = CGRectMake(10, 20, 100, 30);
    [demoBtn addTarget:self action:@selector(addTextItem) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:demoBtn];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    // 创建设置对象
     WKPreferences *preference = [[WKPreferences alloc]init];
     //最小字体大小 当将javaScriptEnabled属性设置为NO时，可以看到明显的效果
     preference.minimumFontSize = 0;
     //设置是否支持javaScript 默认是支持的
     preference.javaScriptEnabled = YES;
     // 在iOS上默认为NO，表示是否允许不经过用户交互由javaScript自动打开窗口
     preference.javaScriptCanOpenWindowsAutomatically = YES;
     config.preferences = preference;
     
     // 是使用h5的视频播放器在线播放, 还是使用原生播放器全屏播放
     config.allowsInlineMediaPlayback = YES;
     //设置视频是否需要用户手动播放  设置为NO则会允许自动播放
     config.mediaTypesRequiringUserActionForPlayback = YES;
     //设置是否允许画中画技术 在特定设备上有效
     config.allowsPictureInPictureMediaPlayback = YES;
     //设置请求的User-Agent信息中应用程序名称 iOS9后可用
     config.applicationNameForUserAgent = @"ChinaDailyForiPad";

    
    NSString *jSString = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
    //用于进行JavaScript注入
    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [config.userContentController addUserScript:wkUScript];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"demoIndex" ofType:@"html"];
    NSString *htmlString = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    CGRect rect = self.view.bounds;
    rect.origin.y = 68;
    self.webView = [[WKWebView alloc]initWithFrame:rect configuration:config];
    self.webView.navigationDelegate = self;
    
    [self.webView loadHTMLString:htmlString baseURL:nil];
    [self.view addSubview:self.webView];
    
    
//    [WebViewJavascriptBridge enableLogging];
    _bridge = [WebViewJavascriptBridge bridgeForWebView:self.webView];
    [_bridge setWebViewDelegate:self];
    
    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"testObjcCallback called: %@", data);
        // 回调js
//        responseCallback(@"Response from testObjcCallback");
    }];
    
    [_bridge registerHandler:@"openAblum" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSDictionary *dict = data;
        self.index = [dict[@"index"] integerValue];
        self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:self.picker animated:YES completion:nil];
        
         NSLog(@"testObjcCallback called: %@", data);
    }];
}

- (void)addTextItem {
    [_bridge callHandler:@"addText" data:@"我就加一行文字" responseCallback:^(id responseData) {
        NSLog(@"addText responseData called: %@", responseData);
    }];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidStartLoad");
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    NSLog(@"webViewDidFinishLoad");
}

#pragma mark UINavigationControllerDelegate, UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    NSData *imgData = UIImageJPEGRepresentation(image, 0.01);
    NSString *encodedImageStr = [imgData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [_bridge callHandler:@"setImage" data:@{@"index":@(self.index).stringValue, @"data":encodedImageStr} responseCallback:^(id responseData) {
        
    }];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//按取消按钮时候的功能
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
