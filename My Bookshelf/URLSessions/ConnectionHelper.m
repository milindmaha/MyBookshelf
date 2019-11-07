//
//  ConnectionHelper.m
//  My Bookshelf
//
//  Created by Milind on 11/3/19.
//  Copyright © 2019 Milind Mahajan. All rights reserved.
//

#import "ConnectionHelper.h"
#import "URLConstants.h"
#import "Book.h"
#import "BookDetails.h"

@implementation ConnectionHelper

typedef void (^ InternalCompletionBlock)(NSData *);
+ (void)performTaskWithURL:(NSURL *)url
										taskType:(NSString *)method
										requestCache:(BOOL)requestCache
						withCompletion:(InternalCompletionBlock)onCompletion {

	NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
	[urlRequest setHTTPMethod:[method uppercaseString]];

	NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
	if (requestCache) {
		[config setURLCache:[NSURLCache sharedURLCache]];
		[config setRequestCachePolicy:NSURLRequestReturnCacheDataElseLoad];
	}
	NSURLSession *session = [NSURLSession sessionWithConfiguration: config];
	[[session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

		NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
		if(httpResponse.statusCode == 200) {
			onCompletion(data);
		} else {
			if (httpResponse.statusCode >= 400
				 && httpResponse.statusCode < 500) {
				NSLog(@"Client Error");
			} else if (httpResponse.statusCode >= 500
								 && httpResponse.statusCode < 600) {
				NSLog(@"Server Error");
			}
			onCompletion(nil);
		}
	}] resume];
}

+ (void)getBookList:(GetBookListCompletionBlock)onCompletion {
	[self performTaskWithURL:[URLConstants urlForList]
									taskType:@"GET"
										requestCache:false
						withCompletion:^(NSData *responseData) {
		onCompletion([self parseBookList:responseData]);
	}];
}

+ (void)getBookIconFromUrl:(NSString *)urlString onCompletion:(GetBookIconCompletionBlock)onCompletion {
	[self performTaskWithURL:[NSURL URLWithString:urlString]
									taskType:@"GET"
										requestCache:true
						withCompletion:^(NSData *responseData) {
		onCompletion(responseData);
	}];
}

+ (void)getBookDetailsForBookId:(NSString *)bookId onCompletion:(GetBookDetailsCompletionBlock)onCompletion {
	[self performTaskWithURL:[URLConstants urlForBookDetailsWithId:bookId]
									taskType:@"GET"
										requestCache:true
						withCompletion:^(NSData *responseData) {

		if (responseData) {
			NSError *parseError = nil;
			NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&parseError];
			if (!parseError) {
				onCompletion([BookDetails bookWithData:responseDictionary]);
			} else {
				onCompletion(nil);
				NSLog(@"Client Error");
			}
		} else {
			onCompletion(nil);
		}
	}];
}

+ (NSArray *)parseBookList:(NSData *)responseData {
	NSMutableArray *parsedBooks = [NSMutableArray array];
	NSError *parseError = nil;
	NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&parseError];
	if (!parseError) {

		if ([responseDictionary objectForKey:@"books"]) {
			NSArray *booksInfo = [responseDictionary objectForKey:@"books"];

			for (NSDictionary *bookInfo in booksInfo) {
				[parsedBooks addObject:[Book bookWithData:bookInfo]];
			}
		}

	} else {
		NSLog(@"Client Error");
	}

	return parsedBooks;
}

+ (void)searchBookList:(NSString *)search pageNumber:(int)page onCompletion:(GetBookListCompletionBlock)onCompletion {
	NSURL *searchUrl = [URLConstants urlForSearchWithQuery:search page:page];
	[self performTaskWithURL:searchUrl taskType:@"GET" requestCache:true withCompletion:^(NSData *responseData) {
		onCompletion([self parseBookList:responseData]);
	}];
}

+ (void)getBookPreviewForUrl:(NSString *)urlString onCompletion:(GetBookPreviewCompletionBlock)onCompletion {
	[self performTaskWithURL:[NSURL URLWithString:urlString]
									taskType:@"GET"
										requestCache:true
						withCompletion:^(NSData *responseData) {
		onCompletion([[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
	}];
}

@end
