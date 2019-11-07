//
//  Book.m
//  My Bookshelf
//
//  Created by Milind on 11/3/19.
//  Copyright © 2019 Milind Mahajan. All rights reserved.
//

#import "Book.h"

@implementation Book

- (id)initWithInfo:(NSDictionary *)info {

	self = [super init];

	if (self) {
		_title = [info objectForKey:@"title"];
		_subtitle = [info objectForKey:@"subtitle"];
		_url = [info objectForKey:@"url"];
		_isbn13 = [info objectForKey:@"isbn13"];
		_image = [info objectForKey:@"image"];
		_price = [info objectForKey:@"price"];
	}

	return self;
}

+ (Book *)bookWithData:(NSDictionary *)info {
	return [[Book alloc] initWithInfo:info];
}

@end
