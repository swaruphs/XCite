//
//  XCiteVideoPlayerViewController.m
//  XCite
//
//  Created by Swarup on 25/9/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "XCiteVideoPlayerViewController.h"
#import "XCitePDFViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface XCiteVideoPlayerViewController ()

@property (weak, nonatomic) IBOutlet UIView *videoHolderView;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (strong, nonatomic) MPMoviePlayerController *player;


@end

@implementation XCiteVideoPlayerViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    
    // setting up the video player.    
    NSString *videoURLPath      = [[NSBundle mainBundle]
                                   pathForResource:self.model.videoURL ofType:@"mp4"];
    NSURL *videoURL             = [NSURL fileURLWithPath:videoURLPath];
    self.player                 = [[MPMoviePlayerController alloc]
                                   initWithContentURL:videoURL];
    self.player.view.frame      = self.videoHolderView.bounds;
    self.player.movieSourceType = MPMovieSourceTypeFile;
    
    [self.videoHolderView addSubview:self.player.view];
    [self.videoHolderView bringSubviewToFront:self.btnClose];
    
    // register for notifications.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoPlayBackStateChanged:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.player];
    
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.player play];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

/**
 *  Dismiss the video player. Action for close button
 *
 *  @param sender Close button
 */
- (IBAction)dismissVideoPlayer:(id)sender
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player stop];
    if (self.moveToPDFOnCompletion) {
        [self showPDFViewer];
    }
    else {
      [self.navigationController popToRootViewControllerAnimated:TRUE];
    }
}

/**
 *  Video player Notification method.
 *
 *  @param notification notification object passed
 */
- (void)videoPlayBackStateChanged:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    NSNumber *reason       = [userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    if ([reason intValue] == MPMovieFinishReasonPlaybackError){
        
    }
    else if([reason intValue] == MPMovieFinishReasonPlaybackEnded) {
        if (self.moveToPDFOnCompletion) {
            [self showPDFViewer];
            return;
        }
        [self.navigationController popToRootViewControllerAnimated:true];
    }
    else if([reason intValue] == MPMovieFinishReasonUserExited) {
        
        // done button clicked!
        
    }
}

/**
 *  Navigate to the pdf viewer. Method called if the video is played from a local notification.
 */
- (void)showPDFViewer
{
    XCitePDFViewController *controller = [[XCitePDFViewController alloc] initWithNibName:@"XCitePDFViewController" bundle:nil];
    controller.model = self.model;
    [self.navigationController pushViewController:controller animated:true];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
