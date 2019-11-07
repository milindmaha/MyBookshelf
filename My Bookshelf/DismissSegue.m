//
//  DismissSegue.m
//  My Bookshelf
//
//  Created by Milind on 11/6/19.
//  Copyright © 2019 Milind Mahajan. All rights reserved.
//

#import "DismissSegue.h"

@implementation DismissSegue

- (void)perform {
	UIViewController *source = self.sourceViewController;
	[source.presentingViewController dismissViewControllerAnimated:true completion:nil];
}

@end
