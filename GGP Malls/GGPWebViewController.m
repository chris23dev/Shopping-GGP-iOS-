//
//  GGPWebViewController.m
//  GGP Malls
//
//  Created by Janet Lin on 1/25/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import "GGPWebViewController.h"
#import "UIFont+GGPAdditions.h"
#import "UIColor+GGPAdditions.h"
#import "NSString+GGPAdditions.h"
#import <AFNetworking/UIWebView+AFNetworking.h>
#import "UINavigationController+GGPAdditions.h"

@interface GGPWebViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (strong, nonatomic) NSURL *webViewUrl;
@property (strong, nonatomic) NSString *analyticsConst;

@end

@implementation GGPWebViewController

- (instancetype)initWithTitle:(NSString *)title urlString:(NSString *)urlString andAnalyticsConst:(NSString *)analyticsConst {
    self = [super init];
    if (self) {
        self.webViewUrl = [NSURL URLWithString:urlString];
        self.analyticsConst = analyticsConst;
        self.title = title;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureWebView];
    self.webView.scrollView.bounces = NO;
    self.webView.delegate = self;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController ggp_configureWithDarkText];
    self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    if (self.analyticsConst) {
        [[GGPAnalytics shared] trackScreen:self.analyticsConst];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}

- (void)configureWebView {
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:self.webViewUrl];
    [self.webView loadRequest:request];
}

#pragma mark UIWebViewDelegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if (navigationType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[request URL]];
        return NO;
    }
    return YES;
}

@end
