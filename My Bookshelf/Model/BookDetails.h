//
//  BookDetails.h
//  My Bookshelf
//
//  Created by Milind on 11/5/19.
//  Copyright © 2019 Milind Mahajan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BookDetails : NSObject

@property (readonly) NSString *isbn13;
@property (readonly) NSString *title;
@property (readonly) NSString *subtitle;
@property (readonly) NSString *price;
@property (readonly) NSString *authors;
@property (readonly) NSString *publisher;
@property (readonly) NSString *language;
@property (readonly) NSString *isbn10;
@property (readonly) int pages;
@property (readonly) int year;
@property (readonly) int rating;
@property (readonly) NSString *desc;

+ (BookDetails *)bookWithData:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
