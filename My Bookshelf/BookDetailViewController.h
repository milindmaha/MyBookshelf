//
//  BookDetailViewController.h
//  My Bookshelf
//
//  Created by Milind on 11/5/19.
//  Copyright © 2019 Milind Mahajan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"
NS_ASSUME_NONNULL_BEGIN

@protocol BookDetailViewControllerProtocol <NSObject>

@optional
- (Book *)getNext;
- (Book *)getPrevious;

@end

@interface BookDetailViewController : UIViewController

@property (weak) Book *book;
@property (weak) id <BookDetailViewControllerProtocol> delegate;

@end

NS_ASSUME_NONNULL_END
