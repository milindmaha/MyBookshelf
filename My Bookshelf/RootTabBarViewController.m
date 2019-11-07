//
//  RootTabBarViewController.m
//  My Bookshelf
//
//  Created by Milind on 11/5/19.
//  Copyright © 2019 Milind Mahajan. All rights reserved.
//

#import "RootTabBarViewController.h"
#import "AppSetting.h"

@interface RootTabBarViewController () <UITabBarControllerDelegate>

@end

@implementation RootTabBarViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.delegate = self;
	[[AppSetting sharedSetting] setSelectedMode:kNewMode];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {

	NSUInteger tabIndex = [tabBarController.viewControllers indexOfObject:viewController];
	AppMode mode = (tabIndex == 0)? kNewMode:kSearchMode;
	[[AppSetting sharedSetting] setSelectedMode:mode];
}

@end
