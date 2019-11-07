//
//  URLConstants.m
//  My Bookshelf
//
//  Created by Milind on 11/3/19.
//  Copyright © 2019 Milind Mahajan. All rights reserved.
//

#import "URLConstants.h"

@implementation URLConstants

static NSString* const protocol = @"https";
static NSString* const basePath = @"api.itbook.store";
static NSString* const version = @"1.0";
+ (NSString *)prepareURL {

	return [NSString stringWithFormat:@"%@://%@/%@/", protocol, basePath, version];
}

static NSString* const listPath = @"new";
+ (NSURL *)urlForList {

	NSMutableString *urlString = [self prepareURL].mutableCopy;
	[urlString appendString:listPath];

	return [NSURL URLWithString: urlString];
}

static NSString* const searchPath = @"search";
+ (NSURL *)urlForSearchWithQuery:(NSString *)search page:(int)page {

	NSMutableString *urlString = [self prepareURL].mutableCopy;
	[urlString appendString:searchPath];
	[urlString appendFormat:@"/%@", search];
	if (page != 1) {
		[urlString appendFormat:@"/%d", page];
	}
	return [NSURL URLWithString:[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]]];
}

static NSString* const detailsPath = @"books";
+ (NSURL *)urlForBookDetailsWithId:(NSString *)bookId {

	NSMutableString *urlString = [self prepareURL].mutableCopy;
	[urlString appendString:detailsPath];
	[urlString appendFormat:@"/%@", bookId];

	return [NSURL URLWithString: urlString];
}

@end
