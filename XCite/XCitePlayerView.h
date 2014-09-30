//
//  XCitePlayerView.h
//  XCite
//
//  Created by Swarup on 25/9/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@class XCitePlayerView;
@protocol  XCitePlayerViewDelegate

- (void)XCitePlayerView:(XCitePlayerView *)playerView playVideoAtIndex:(NSUInteger)index;
- (void)XCitePlayerView:(XCitePlayerView *)playerView openPDFAtIndex:(NSUInteger)index;

@end

@interface XCitePlayerView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lblbVideoTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblVideoSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *pdfTitle;
@property (weak, nonatomic) IBOutlet UILabel *pdfSubTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgVideoTile;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) AVPlayer *avPlayer;
@property (weak, nonatomic) id<XCitePlayerViewDelegate> delegate;

- (id)initWithNibName:(NSString *)nibName;

- (void)setUpVideoPlayerWithURL:(NSString *)fileURL;

+ (instancetype)xCitePlayerViewWithModel:(XCiteModel *)model withYOffet:(NSUInteger)yOffset;

@end
