//
//  XCitePlayerView.m
//  XCite
//
//  Created by Swarup on 25/9/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "XCitePlayerView.h"

@interface XCitePlayerView()

@property (weak, nonatomic) IBOutlet UIView *videoHolderView;
@property (weak, nonatomic) IBOutlet UILabel *lblJoinUs;

@end


@implementation XCitePlayerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (instancetype)xCitePlayerViewWithModel:(XCiteModel *)model withYOffet:(NSUInteger)yOffset
{
    XCitePlayerView *view = [[XCitePlayerView alloc] initWithNibName:NSStringFromClass([XCitePlayerView class])];
    view.top = yOffset;
    [view setUpViews:model];
    return view;
}

- (id)initWithNibName:(NSString *)nibName
{
    self = [super init];
    if (self == nil)
        return nil;
    
    // Initialization code
    self = [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] objectAtIndex:0];
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    
}

- (void)setUpViews:(XCiteModel *)model
{
    self.webView.userInteractionEnabled = NO;
    self.imgVideoTile.image = [UIImage imageNamed:model.videoTile];
    
    UIFont *titleFont  = [UIFont fontWithName:@"RockwellStd" size:33];
    self.lblbVideoTitle.font = titleFont;
    self.pdfTitle.font = titleFont;
    
    self.lblbVideoTitle.text = model.videoTitle;
    self.lblVideoSubTitle.text =  model.videoSubTitle;
    self.pdfTitle.text = model.pdfTitle;
    self.pdfSubTitle.text =  model.pdfSubTitle;

    self.lblbVideoTitle.textColor = [UIColor colorWithHexString:model.titleColor];
    self.pdfTitle.textColor = [UIColor colorWithHexString:model.titleColor];
    
    self.lblJoinUs.font = [UIFont fontWithName:@"RockwellStd" size:22];
    
    NSString *pdfURL = [[NSBundle mainBundle] pathForResource:model.pdfURL ofType:@"pdf"];
    [self setUpWebView:pdfURL];
}

- (void)setUpVideoPlayerWithURL:(NSString *)fileURL
{
    AVAsset *asset  = [AVAsset assetWithURL:[NSURL fileURLWithPath:fileURL]];
    AVPlayerItem *item  = [[AVPlayerItem alloc] initWithAsset:asset];
    self.avPlayer = [[AVPlayer alloc] initWithPlayerItem:item];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.avPlayer];
    layer.frame = self.videoHolderView.bounds;
    [self.videoHolderView.layer addSublayer:layer];
    [self.avPlayer seekToTime:kCMTimeZero];
}

- (void)setUpWebView:(NSString *)urlString
{
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:urlString]]];
}

#pragma mark - Actions

- (IBAction)onBtnPlayVideo:(id)sender
{
    [self.delegate XCitePlayerView:self playVideoAtIndex:self.tag];
}

- (IBAction)onBtnOpenPDF:(id)sender
{
    [self.delegate XCitePlayerView:self openPDFAtIndex:self.tag];
}

@end
