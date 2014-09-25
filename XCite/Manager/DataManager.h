//
//  DataManager.h
//  XCite
//
//  Created by Swarup on 25/9/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

+ (id)sharedInstance;
- (NSArray *)getAllModels;

@end
