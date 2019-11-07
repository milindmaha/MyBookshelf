//
//  ConnectionHelper.h
//  My Bookshelf
//
//  Created by Milind on 11/3/19.
//  Copyright © 2019 Milind Mahajan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConnectionHelper : NSObject

typedef void (^ GetBookListCompletionBlock)(NSArray * _Nullable);
+ (void)getBookList:(GetBookListCompletionBlock)onCompletion;
+ (void)searchBookList:(NSString *)search pageNumber:(int)page onCompletion:(GetBookListCompletionBlock)onCompletion;

typedef void (^ GetBookIconCompletionBlock)(NSData * _Nullable);
+ (void)getBookIconFromUrl:(NSString *)urlString onCompletion:(GetBookIconCompletionBlock)onCompletion;

typedef void (^ GetBookDetailsCompletionBlock)(id _Nullable);
+ (void)getBookDetailsForBookId:(NSString *)bookId onCompletion:(GetBookDetailsCompletionBlock)onCompletion;

typedef void (^ GetBookPreviewCompletionBlock)(NSString * _Nullable);
+ (void)getBookPreviewForUrl:(NSString *)urlString onCompletion:(GetBookPreviewCompletionBlock)onCompletion;

@end

NS_ASSUME_NONNULL_END
