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
    NSString *pdfPath = [[NSBundle mainBundle]
                         pathForResource:self.model.pdfURL ofType:@"pdf"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:pdfPath]]];
    self.toolbarView.hidden            = YES;
    _toolbarShown                      = NO;

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]
                                          initWithTarget:self action:@selector(showToolbar)];
    tapGesture.numberOfTapsRequired    = 1.0f;
    [self.webView addGestureRecognizer:tapGesture];
    self.webView.scrollView.delegate   = self;
    
    UIFont *btnFont                     = [UIFont fontWithName:@"RockwellStd" size:24];
    self.btnClose.titleLabel.font       = btnFont;
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

#pragma mark - Private methods

- (void)showPopup
{
    NSString *savedEmail = [[XCiteCacheManager sharedInstance] savedEmail];
    [XCiteSharePopup initPopupWithEmail:savedEmail completionBlock:^(NSInteger index, XCiteSharePopup *popupView) {
        
        if (index == 0) {
            [popupView dismiss];
        }
        else  {
            NSString *emailText = popupView.txtField.text;
            if([emailText isEmail]) {
                [popupView dismiss];
                [self sendEmailTo:emailText];
                [[XCiteCacheManager sharedInstance] saveEmail:emailText];
            }
            else {
                [popupView.txtField  shakeAnimation];
            }
        }
    }];
}

- (void)sendEmailTo:(NSString *)email
{
    [[XCiteNetworkManager sharedInstance] sendEmailTo:email withPDF:self.model.pdfURL];
}

- (void)showToolbar
{
    if (_toolbarShown) {
        return;
    }
    self.toolbarView.hidden = NO;
    self.toolbarView.bottom = self.view.top;
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.toolbarView.top = 0.0f;
    } completion:^(BOOL finished) {
        _toolbarShown = YES;
    }];
}

- (void)hideToolbar
{
    [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.toolbarView.bottom = self.view.top;
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
