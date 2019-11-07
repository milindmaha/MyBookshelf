//
//  AppSetting.h
//  My Bookshelf
//
//  Created by Milind on 11/5/19.
//  Copyright © 2019 Milind Mahajan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum AppMode {
	kNewMode = 0,
	kSearchMode = 1
} AppMode;

@interface AppSetting : NSObject

@property (nonatomic) AppMode selectedMode;

+ (id)sharedSetting;

@end

NS_ASSUME_NONNULL_END
