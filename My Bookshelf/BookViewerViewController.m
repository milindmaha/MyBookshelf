//
//  BookViewerViewController.m
//  My Bookshelf
//
//  Created by Milind on 11/6/19.
//  Copyright © 2019 Milind Mahajan. All rights reserved.
//

#import "BookViewerViewController.h"
#import <WebKit/WebKit.h>
#import "ConnectionHelper.h"

@interface BookViewerViewController () {
	WKWebView *webview;
}

@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@end

@implementation BookViewerViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	/** This code upto line 33 is copied from stackoverflow*/
	NSString *script = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
	WKUserScript *userScript = [[WKUserScript alloc] initWithSource:script injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:true];
	WKUserContentController *controller = [[WKUserContentController alloc] init];
	[controller addUserScript:userScript];
	
	WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
	config.userContentController = controller;
	webview = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:config];

	[webview setTranslatesAutoresizingMaskIntoConstraints:false];
	[self.view addSubview:webview];

	[[webview.topAnchor constraintEqualToAnchor:self.doneButton.bottomAnchor] setActive:true];
	[[webview.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:true];
	[[webview.bottomAnchor constraintEqualToAnchor:self.view.bottomAnchor] setActive:true];
	[[webview.leftAnchor constraintEqualToAnchor:self.view.leftAnchor] setActive:true];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	[ConnectionHelper getBookPreviewForUrl:self.urlString onCompletion:^(NSString * _Nullable htmlString) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self->webview loadHTMLString:htmlString baseURL:[NSURL URLWithString:self->_urlString]];
		});
	}];
}

@end
