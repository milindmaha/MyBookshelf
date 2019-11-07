//
//  BooksTableViewCell.h
//  My Bookshelf
//
//  Created by Milind on 11/5/19.
//  Copyright © 2019 Milind Mahajan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Book.h"

NS_ASSUME_NONNULL_BEGIN

@interface BooksTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property Book *book;

- (void)refreshUI:(Book *)book;
@end

NS_ASSUME_NONNULL_END
