//
//  XCitePDFViewController.m
//  XCite
//
//  Created by Swarup on 26/9/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "XCitePDFViewController.h"
#import "XCiteSharePopup.h"

@interface XCitePDFViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation XCitePDFViewController

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

@end
