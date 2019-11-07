//
//  URLConstants.h
//  My Bookshelf
//
//  Created by Milind on 11/3/19.
//  Copyright © 2019 Milind Mahajan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface URLConstants : NSObject

+ (NSURL *)urlForList;
+ (NSURL *)urlForSearchWithQuery:(NSString *)search page:(int)page;
+ (NSURL *)urlForBookDetailsWithId:(NSString *)bookId;

@end

NS_ASSUME_NONNULL_END
