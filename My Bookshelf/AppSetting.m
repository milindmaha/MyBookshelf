//
//  AppSetting.m
//  My Bookshelf
//
//  Created by Milind on 11/5/19.
//  Copyright © 2019 Milind Mahajan. All rights reserved.
//

#import "AppSetting.h"

@implementation AppSetting

+ (id)sharedSetting {
    static AppSetting *sharedSetting = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSetting = [[self alloc] init];
    });

	return sharedSetting;
}

- (id)init {
  if (self = [super init]) {
      _selectedMode = kNewMode;
  }
  return self;
}

@end
