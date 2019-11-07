//
//  BooksTableViewCell.m
//  My Bookshelf
//
//  Created by Milind on 11/5/19.
//  Copyright © 2019 Milind Mahajan. All rights reserved.
//

#import "BooksTableViewCell.h"
#import "ConnectionHelper.h"

@interface BooksTableViewCell() {
	UIStackView *stackView;
}

@end

@implementation BooksTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)prepareForReuse {
	[super prepareForReuse];
	self.iconImageView.image = nil;
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

	if (stackView) {
		[stackView removeFromSuperview];
		stackView = nil;
	}
	stackView = [[UIStackView alloc] init];
	stackView.axis = UILayoutConstraintAxisVertical;
	stackView.spacing = 3;
	stackView.layoutMargins = UIEdgeInsetsMake(8, 8, 8, 8);
	[stackView setLayoutMarginsRelativeArrangement:true];
	
	if (book.isbn13) {
		UILabel *isbnLabel = [self getLabelWithText:book.isbn13];
		[stackView addArrangedSubview:isbnLabel];
	}
	if (book.title) {
		UILabel *titleLabel = [self getLabelWithText:book.title];
		[stackView addArrangedSubview:titleLabel];
	}
	if (book.subtitle) {
		UILabel *subtitleLabel = [self getLabelWithText:book.subtitle];
		[stackView addArrangedSubview:subtitleLabel];
	}
	if (book.price) {
		UILabel *priceLabel = [self getLabelWithText:book.price];
		[stackView addArrangedSubview:priceLabel];
	}
	stackView.translatesAutoresizingMaskIntoConstraints = false;
	[self.contentView addSubview:stackView];

	[[stackView.topAnchor constraintEqualToAnchor:self.contentView.topAnchor] setActive:true];
	[[stackView.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor] setActive:true];
	[[stackView.bottomAnchor constraintEqualToAnchor:self.contentView.bottomAnchor] setActive:true];
	[[stackView.leftAnchor constraintEqualToAnchor:self.iconImageView.rightAnchor] setActive:true];
}

- (UILabel *)getLabelWithText:(NSString *)text {
	UILabel *label = [[UILabel alloc] init];
	label.text = text;
	label.numberOfLines = 0;
	label.lineBreakMode = NSLineBreakByWordWrapping;
	
	return label;
}

@end
