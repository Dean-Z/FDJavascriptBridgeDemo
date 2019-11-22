//
//  WebController.m
//  JS_OCDemo
//
//  Created by Jason on 2019/11/22.
//  Copyright © 2019 Jason. All rights reserved.
//

#import "WebController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "JavascriptBridgeVC.h"
#import "NameModel.h"

@interface WebController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation WebController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 68)];
    topView.backgroundColor = [UIColor systemRedColor];
    [self.view addSubview:topView];
    
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"index" ofType:@"html"];
    NSString *htmlString = [[NSString alloc]initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    CGRect rect = self.view.bounds;
    rect.origin.y = 68;
    self.webView = [[UIWebView alloc]initWithFrame:rect];
    [self.webView loadHTMLString:htmlString baseURL:nil];
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    JSContext *jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    [jsContext evaluateScript:@"var name = ['hello','123','我是按钮']"];
    NameModel *model = [[NameModel alloc]init];
    model.name = @"跳转到JavascriptBridgeVC";
    jsContext[@"ocModel"] = model;
    
    jsContext[@"showMessage"] = ^(){
        NSArray *args = [JSContext currentArguments];
        NSLog(@"回调到了 -- %@",args);
        
        [[JSContext currentContext][@"addItems"] callWithArguments:@[@"按钮啊"]];
    };
    
    jsContext[@"jumpToWk"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            JavascriptBridgeVC *vc = [JavascriptBridgeVC new];
            [self presentViewController:vc animated:YES completion:nil];
        });
    };
}

@end
