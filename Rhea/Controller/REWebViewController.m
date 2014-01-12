//
//  CNSWebViewController.m
//  Cronus
//
//  Created by Tiger on 13-11-27.
//  Copyright (c) 2013年 CheXiaoDi. All rights reserved.
//

#import "REWebViewController.h"

@interface REWebViewController ()
<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, copy) NSString *urlString;

@end



@implementation REWebViewController

- (id)initWithUrlString:(NSString *)urlString
{
    self = [super init];
    if (self) {
        self.urlString = urlString;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, kScreenIs4InchRetina?504.0f:416.0f)];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]];
    [SVProgressHUD show];
    [self.webView loadRequest:request];
    
    [self configToolBar];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [SVProgressHUD dismiss];
}


- (void)configToolBar
{
    UIView *toolBar = [[UIView alloc] initWithFrame:CGRectMake(0.0f, ([UIScreen mainScreen].bounds.size.height - 20.0f - 88.0f), 320.0f, 44.0f)];
    toolBar.backgroundColor = [UIColor grayColor];
    [self.view addSubview:toolBar];
    
    UIButton *forwardButton = [[UIButton alloc] initWithFrame:CGRectMake(70.0f, 0.0f, 44.0f, 44.0f)];
    [forwardButton setImage:[UIImage imageNamed:@"webview_forward_normal"] forState:UIControlStateNormal];
    [forwardButton setImage:[UIImage imageNamed:@"webview_forward_highlithed"] forState:UIControlStateHighlighted];
    [forwardButton addTarget:self action:@selector(handleForwardButtonButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:forwardButton];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(20.0f, 0.0f, 44.0f, 44.0f)];
    [backButton setImage:[UIImage imageNamed:@"webview_back_normal"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"webview_back_hithlighted"] forState:UIControlStateHighlighted];
    [backButton addTarget:self action:@selector(handleBackButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:backButton];
    
    UIButton *refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(250.0f, 0.0f, 44.0f, 44.0f)];
    [refreshButton setImage:[UIImage imageNamed:@"webview_refresh_normal"] forState:UIControlStateNormal];
    [refreshButton setImage:[UIImage imageNamed:@"webview_refresh_hithlighted"] forState:UIControlStateHighlighted];
    [refreshButton addTarget:self action:@selector(handleRefreshButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:refreshButton];
}


- (void)handleBackButtonTapped:(UIButton *)sender
{
    if ([self.webView canGoBack]) {
        [self.webView goBack];
    }
}


- (void)handleForwardButtonButtonTapped:(UIButton *)sender
{
    if ([self.webView canGoForward]) {
        [self.webView goForward];
    }
}


- (void)handleRefreshButtonTapped:(UIButton *)sender
{
    [self.webView reload];
}


#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [SVProgressHUD dismiss];
}


- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    //[SVProgressHUD showErrorWithStatus:error.localizedDescription];
}

@end
