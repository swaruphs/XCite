//
//  XCiteModel.h
//  XCite
//
//  Created by Swarup on 25/9/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCiteModel : NSObject


@property (strong, nonatomic) NSString * videoTitle; // video title
@property (strong, nonatomic) NSString * videoSubTitle; // video subtitle
@property (strong, nonatomic) NSString * videoURL; // video file url
@property (strong, nonatomic) NSString * videoTile; // video tile image
@property (strong, nonatomic) NSString * titleColor; // text color
@property (strong, nonatomic) NSString * pdfTitle; // pdf title
@property (strong, nonatomic) NSString * pdfSubTitle; // pdf subtitle
@property (strong, nonatomic) NSString * pdfURL; // file url for pdf
@property (strong, nonatomic) NSString * onImage; // side bar on image for category
@property (strong, nonatomic) NSString * offImage; // side bar off image for category
@property (strong, nonatomic) NSString * identifier; // identifier of the category
@property (strong, nonatomic) NSString * notificationTitle; // notification title
@property (strong, nonatomic) NSString * notificationSubTitle; // notification subtitle.

- (id)initWithDictionary:(NSDictionary *)inputDic;



@end
