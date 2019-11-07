//
//  Book.h
//  My Bookshelf
//
//  Created by Milind on 11/3/19.
//  Copyright © 2019 Milind Mahajan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Book : NSObject

@property (readonly) NSString *title;
@property (readonly) NSString *subtitle;
@property (readonly) NSString *url;
@property (readonly) NSString *isbn13;
@property (readonly) NSString *image;
@property (readonly) NSString *price;

+ (Book *)bookWithData:(NSDictionary *)info;

@end

NS_ASSUME_NONNULL_END
