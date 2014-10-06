//
//  XCiteJoinUsPopup.m
//  XCite
//
//  Created by Swarup on 3/10/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import "XCiteJoinUsPopup.h"
#import <objc/runtime.h>

@interface XCiteJoinUsPopup()

@property (nonatomic, weak) IBOutlet UIButton *btnSend;
@property (nonatomic, weak) IBOutlet UIButton *btnCancel;

@end

@implementation XCiteJoinUsPopup

+ (instancetype)showPopupWithEmail:(NSString *)email  completionBlock:(void (^)(NSInteger index, XCiteJoinUsPopup * popupView))completionBlock
{
    XCiteJoinUsPopup *popUp = [[XCiteJoinUsPopup alloc] initWithNib];
    [popUp setUpWithCompletionBlock:completionBlock];
    [popUp show];
    return popUp;
    
}

- (void)setUpWithCompletionBlock:(void (^)(NSInteger index, XCiteJoinUsPopup * popupView))completionBlock
{
    UIColor *appBlueColor = [UIColor colorWithHexString:@"#00a5db"];
    
    self.txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.txtEmail.placeholder attributes:@{NSForegroundColorAttributeName: appBlueColor}];
    
    self.txtFirstName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.txtFirstName.placeholder attributes:@{NSForegroundColorAttributeName:appBlueColor}];
    
    self.txtLastName.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.txtLastName.placeholder attributes:@{NSForegroundColorAttributeName: appBlueColor}];
    
    self.btnSend.titleLabel.font = [UIFont fontWithName:@"RockwellStd" size:24];
    self.btnCancel.titleLabel.font = [UIFont fontWithName:@"RockwellStd" size:24];
    
    for (UIButton * btn in self.btnTitles) {
        btn.titleLabel.font = [UIFont fontWithName:@"RockwellStd" size:24];
    }
    
    if (completionBlock)
        objc_setAssociatedObject(self, "completionBlockCallback", [completionBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#pragma mark - Actions

- (IBAction)onBtnTitle:(id)sender
{
    if (sender == self.selectedBtn) {
        return;
    }
    
    for (UIButton *btn in self.btnTitles) {
        if (btn == sender) {
            [self highlightButton:btn];
        }
        else {
            [self unhighlightButton:btn];
        }
    }
}

- (IBAction)onBtnGeneric:(UIButton *)sender
{
    [self performCallBack:sender];
}

#pragma mark - Private Methods

- (void)highlightButton:(UIButton *)btn
{
    btn.alpha = 1.0f;
    self.selectedBtn = btn;
}

- (void)unhighlightButton:(UIButton *)btn
{
    btn.alpha = 0.3f;
}

- (void)performCallBack:(UIButton *)sender
{
    //get back the block object attribute we set earlier
    void (^block)(NSInteger index, XCiteJoinUsPopup * popupView) = objc_getAssociatedObject(self, "completionBlockCallback");
    if (block)
        block(sender.tag - 100, self);

}

@end
