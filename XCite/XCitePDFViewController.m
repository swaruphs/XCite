//
//  XCitePDFViewController.m
//  XCite
//
//  Created by Swarup on 26/9/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "XCitePDFViewController.h"
#import "XCiteSharePopup.h"

@interface XCitePDFViewController ()
<UIWebViewDelegate,
UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *toolbarView;
@property (weak, nonatomic) IBOutlet UIButton *btnClose;
@property (weak, nonatomic) IBOutlet UIButton *btnSendMeACopy;

@end

@implementation XCitePDFViewController
{
    BOOL _toolbarShown;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self _init];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)_init
{
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:self.model.pdfURL]]];
    self.toolbarView.hidden  = YES;
    _toolbarShown = NO;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showToolbar)];
    tapGesture.numberOfTapsRequired = 1.0f;
    [self.webView addGestureRecognizer:tapGesture];
    self.webView.scrollView.delegate = self;
    
    UIFont *btnFont  = [UIFont fontWithName:@"RockwellStd" size:24];
    self.btnClose.titleLabel.font = btnFont;
    self.btnSendMeACopy.titleLabel.font = btnFont;
    
}

#pragma mark - Actions

- (IBAction)onBtnClose:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:TRUE];
}

- (IBAction)onBtnShare:(id)sender
{
    [self showPopup];
}

- (void)showPopup
{
    [XCiteSharePopup initPopupWithEmail:@"soemthing@gmail.com" completionBlock:^(NSInteger index, XCiteSharePopup *popupView) {
        [popupView dismiss];
        NSLog(@"clicked button index %ld",index);
    }];
}

- (void)showToolbar
{
    if (_toolbarShown) {
        return;
    }
    self.toolbarView.hidden = NO;
    self.toolbarView.top = self.view.height;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.toolbarView.top = self.view.height - 60;
    } completion:^(BOOL finished) {
        _toolbarShown = YES;
    }];
}

- (void)hideToolbar
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.toolbarView.top = self.view.height;
    } completion:^(BOOL finished) {
        self.toolbarView.hidden = YES;
        _toolbarShown = NO;
    }];
}

#pragma mark  - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_toolbarShown) {
        _toolbarShown = NO;
        [self hideToolbar];
    }
}

@end
