//
//  BookDetails.m
//  My Bookshelf
//
//  Created by Milind on 11/5/19.
//  Copyright © 2019 Milind Mahajan. All rights reserved.
//

#import "BookDetails.h"

@implementation BookDetails

- (id)initWithInfo:(NSDictionary *)info {

	self = [super init];

	if (self) {
		_isbn13 = [info objectForKey:@"isbn13"];
		_title = [info objectForKey:@"title"];
		_subtitle = [info objectForKey:@"subtitle"];
		_price = [info objectForKey:@"price"];
		_authors = [info objectForKey:@"authors"];
		_publisher = [info objectForKey:@"publisher"];
		_language = [info objectForKey:@"language"];
		_isbn10 = [info objectForKey:@"isbn10"];
		_pages = [[info objectForKey:@"pages"] intValue];
		_year = [[info objectForKey:@"year"] intValue];
		_rating = [[info objectForKey:@"rating"] intValue];
		_desc = [info objectForKey:@"desc"];
	}

	return self;
}

+ (BookDetails *)bookWithData:(NSDictionary *)info {
	return [[BookDetails alloc] initWithInfo:info];
}

@end
