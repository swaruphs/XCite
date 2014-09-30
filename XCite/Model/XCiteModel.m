//
//  XCiteModel.m
//  XCite
//
//  Created by Swarup on 25/9/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "XCiteModel.h"

@implementation XCiteModel

- (instancetype)initWithDictionary:(NSDictionary *)inputDic
{
    self = [super init];
    if (self) {
        [self updateWithDictionary:inputDic];
    }
    
    return self;
}

- (void)updateWithDictionary:(NSDictionary *)inputDic
{
    NSString *videoPath       = [inputDic stringForKey:@"videoURL"];
    self.videoURL             = [[NSBundle mainBundle] pathForResource:videoPath ofType:@"mp4"];
    self.videoTitle           = [inputDic stringForKey:@"videoTitle"];
    self.videoSubTitle        = [inputDic stringForKey:@"videoSubTitle"];
    self.videoTile            = [inputDic stringForKey:@"videoTile"];

    NSString *pdfPath         = [inputDic stringForKey:@"pdfURL"];
    self.pdfURL               = [[NSBundle mainBundle] pathForResource:pdfPath ofType:@"pdf"];
    self.pdfTitle             = [inputDic stringForKey:@"pdfTitle"];
    self.pdfSubTitle          = [inputDic stringForKey:@"pdfSubTitle"];

    self.onImage              = [inputDic stringForKey:@"img_on"];
    self.offImage             = [inputDic stringForKey:@"img_off"];
    self.identifier           = [inputDic stringForKey:@"identifier"];
    self.notificationTitle    = [inputDic stringForKey:@"notificationTitle"];
    self.notificationSubTitle = [inputDic stringForKey:@"notificationSubtitle"];
}

@end
