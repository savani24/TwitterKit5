/*
 * Copyright (C) 2017 Twitter, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

#import "TWTRWebViewController.h"
#import <TwitterCore/TWTRAuthenticationConstants.h>

@interface TWTRWebViewController () <WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, assign) BOOL showCancelButton;
@property (nonatomic, copy) TWTRWebViewControllerCancelCompletion cancelCompletion;

@end

@implementation TWTRWebViewController

// Conversion from UIWebViewNavigationType to WKNavigationType
+ (UIWebViewNavigationType)_enumHelperForNavigationType:(WKNavigationType)wkNavigationType {
    switch (wkNavigationType) {
        case WKNavigationTypeLinkActivated:
            return UIWebViewNavigationTypeLinkClicked;
            break;
        case WKNavigationTypeFormSubmitted:
            return UIWebViewNavigationTypeFormSubmitted;
            break;
        case WKNavigationTypeBackForward:
            return UIWebViewNavigationTypeBackForward;
            break;
        case WKNavigationTypeReload:
            return UIWebViewNavigationTypeReload;
            break;
        case WKNavigationTypeFormResubmitted:
            return UIWebViewNavigationTypeFormResubmitted;
            break;
        case WKNavigationTypeOther:
        default:
            return UIWebViewNavigationTypeOther;
            break;
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setTitle:@"Twitter"];
    if ([self showCancelButton]) {
        [[self navigationItem] setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)]];
    }
    [self load];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Interface implementations

- (void)load
{
    [[self webView] loadRequest:[self request]];
}

#pragma mark - View controller lifecycle

- (void)loadView
{
    [self initWebView];
    [self setView:[self webView]];
}

#pragma mark - WKWebview delegate

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSURLRequest* request = navigationAction.request;
    if (![self whitelistedDomain:request]) {
        // Open in Safari if request is not whitelisted
        NSLog(@"Opening link in Safari browser, as the host is not whitelisted: %@", request.URL);
        [[UIApplication sharedApplication] openURL:request.URL];
        decisionHandler(WKNavigationActionPolicyCancel);
        return;
    }
    WKNavigationActionPolicy decision = WKNavigationActionPolicyAllow;
    if ([self shouldStartLoadWithRequest]) {
        if (![self shouldStartLoadWithRequest](self, request, [TWTRWebViewController _enumHelperForNavigationType:navigationAction.navigationType])) {
            decision = WKNavigationActionPolicyCancel;
        };
    }

    decisionHandler(decision);
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (self.errorHandler) {
        self.errorHandler(error);
        self.errorHandler = nil;
    }
}

#pragma mark - Internal methods

- (BOOL)whitelistedDomain:(NSURLRequest *)request
{
    NSString *whitelistedHostWildcard = [@"." stringByAppendingString:TWTRTwitterDomain];
    NSURL *url = request.URL;
    NSString *host = url.host;
    return ([host isEqualToString:TWTRTwitterDomain] || [host hasSuffix:whitelistedHostWildcard] || ([TWTRSDKScheme isEqualToString:url.scheme] && [TWTRSDKRedirectHost isEqualToString:host]));
}

- (void)cancel
{
    if ([self cancelCompletion]) {
        [self cancelCompletion](self);
        self.cancelCompletion = nil;
    }
}

- (void)enableCancelButtonWithCancelCompletion:(TWTRWebViewControllerCancelCompletion)cancelCompletion
{
    NSAssert([self isViewLoaded] == NO, @"This method must be called before the view controller is presented");
    [self setShowCancelButton:YES];
    [self setCancelCompletion:cancelCompletion];
}

- (void)initWebView {
    // From: https://stackoverflow.com/questions/26295277/wkwebview-equivalent-for-uiwebviews-scalespagetofit
    NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";

    WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController *wkUController = [[WKUserContentController alloc] init];
    [wkUController addUserScript:wkUScript];

    WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
    wkWebConfig.userContentController = wkUController;

    WKWebView* wkWebV = [[WKWebView alloc] initWithFrame: self.parentViewController.view.frame configuration:wkWebConfig];

    [self setWebView:wkWebV];
    [[self webView] setNavigationDelegate:self];

}
@end
