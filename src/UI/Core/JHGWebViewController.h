//
//  Created by JasonHu on 2018/12/6.
//  Copyright © 2018年 Jingchen Hu. All rights reserved.
//
#import "UIViewController+JHGarage.h"

#import <WebKit/WebKit.h>

@interface JHGWebViewController : UIViewController<WKNavigationDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) WKWebViewConfiguration *wkConfig;

@property (nonatomic, strong) NSString *url;
- (void)reloadWithUrl:(NSString *)url;

@end
