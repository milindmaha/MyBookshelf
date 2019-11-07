//
//  BooksTableViewCell.m
//  My Bookshelf
//
//  Created by Milind on 11/5/19.
//  Copyright © 2019 Milind Mahajan. All rights reserved.
//

#import "BooksTableViewCell.h"
#import "ConnectionHelper.h"

@implementation BooksTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)prepareForReuse {
	[super prepareForReuse];
	self.iconImageView.image = nil;
	for (id subview in self.stackView.arrangedSubviews) {
		if ([subview isKindOfClass:[UILabel class]]) {
			[subview removeFromSuperview];
		}
	}
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	
	self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	[self refreshUI:self.book];
}

- (void)refreshUI:(Book *)book {
	self.book = book;
	[ConnectionHelper getBookIconFromUrl:book.image onCompletion:^(NSData * _Nullable imageData) {
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.iconImageView setImage:[UIImage imageWithData:imageData]];
		});
	}];

	if (book.isbn13) {
		UILabel *isbnLabel = [self getLabelWithText:book.isbn13];
		[self.stackView addArrangedSubview:isbnLabel];
	}
	if (book.title) {
		UILabel *titleLabel = [self getLabelWithText:book.title];
		[self.stackView addArrangedSubview:titleLabel];
	}
	if (book.subtitle) {
		UILabel *subtitleLabel = [self getLabelWithText:book.subtitle];
		[self.stackView addArrangedSubview:subtitleLabel];
	}
	if (book.price) {
		UILabel *priceLabel = [self getLabelWithText:book.price];
		[self.stackView addArrangedSubview:priceLabel];
	}
}

- (UILabel *)getLabelWithText:(NSString *)text {
	UILabel *label = [[UILabel alloc] init];
	label.text = text;
	label.numberOfLines = 0;
	label.lineBreakMode = NSLineBreakByWordWrapping;
	
	return label;
}

@end
