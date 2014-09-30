//
//  XCiteModel.h
//  XCite
//
//  Created by Swarup on 25/9/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCiteModel : NSObject


@property (strong, nonatomic) NSString * videoTitle;
@property (strong, nonatomic) NSString * videoSubTitle;
@property (strong, nonatomic) NSString * videoURL;
@property (strong, nonatomic) NSString * videoTile;
@property (strong, nonatomic) NSString * pdfTitle;
@property (strong, nonatomic) NSString * pdfSubTitle;
@property (strong, nonatomic) NSString * pdfURL;
@property (strong, nonatomic) NSString * onImage;
@property (strong, nonatomic) NSString * offImage;
@property (strong, nonatomic) NSString * identifier;
@property (strong, nonatomic) NSString * notificationTitle;
@property (strong, nonatomic) NSString * notificationSubTitle;

- (id)initWithDictionary:(NSDictionary *)inputDic;



@end
