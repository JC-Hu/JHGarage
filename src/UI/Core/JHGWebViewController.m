//
//  Created by JasonHu on 2018/12/6.
//  Copyright © 2018年 Jingchen Hu. All rights reserved.
//


#import "JHGWebViewController.h"

@interface JHGWebViewController ()

@end

@implementation JHGWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    
    if (self.url) {
        [self reloadWithUrl:self.url];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}


- (void)setupViews
{
    [self.view addSubview:self.webView];
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshButtonAction:)];
}



#pragma mark - public
- (void)reloadWithUrl:(NSString *)url
{
    self.url = url;
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    [self.webView loadRequest:request];
}

#pragma mark - interaction
- (void)refreshButtonAction:(id)sender
{
    [self reloadWithUrl:self.url];
}

- (BOOL)navigationShouldPopOnBackButton
{
    if (self.webView.backForwardList.backItem) {
        
        [self.webView goBack];
       
        return NO;
    } else {
        return YES;
    }
}


#pragma mark - get

- (WKWebView *)webView
{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self.wkConfig];
        _webView.navigationDelegate = self;
        _webView.scrollView.delegate = self;
    }
    
    
    return _webView;
}

- (WKWebViewConfiguration *)wkConfig
{
    if (!_wkConfig) {
        _wkConfig = [[WKWebViewConfiguration alloc] init];
    }
    return _wkConfig;
}

@end
