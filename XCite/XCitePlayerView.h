//
//  XCitePlayerView.h
//  XCite
//
//  Created by Swarup on 25/9/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface XCitePlayerView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lblbVideoTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblVideoSubTitle;
@property (weak, nonatomic) IBOutlet UILabel *pdfTitle;
@property (weak, nonatomic) IBOutlet UILabel *pdfsubTitle;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) AVPlayer *avPlayer;

- (id)initWithNibName:(NSString *)nibName;

- (void)setUpVideoPlayerWithURL:(NSString *)fileURL;

@end
