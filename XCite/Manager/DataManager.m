//
//  DataManager.m
//  XCite
//
//  Created by Swarup on 25/9/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "DataManager.h"

@interface DataManager()

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation DataManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t pred;
    static id __singleton = nil;
    
    dispatch_once(&pred, ^{ __singleton = [[self alloc] init]; });
    return __singleton;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self getAllModels];
    }
    return self;
}

- (NSArray *)getAllModels
{
    if ([self.dataArray isNotEmpty]) {
        return self.dataArray;
    }
    
    self.dataArray = [NSMutableArray array];
    NSString *contentPath = [[NSBundle mainBundle] pathForResource:@"content" ofType:@"plist"];
    NSArray *contents = [NSArray arrayWithContentsOfFile:contentPath];

    for(NSDictionary * inputDic in contents) {
        XCiteModel *model = [[XCiteModel alloc] initWithDictionary:inputDic];
        [self.dataArray addObject:model];
    }
    
    return self.dataArray;
}

@end
