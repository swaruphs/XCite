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

@end


@implementation XCitePlayerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
        [self setUpViews];
    }
    return self;
}

- (void)awakeFromNib
{
    [self setUpViews];
}

- (void)setUpViews
{
    
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

@end
