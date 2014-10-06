//
//  EGCPopupView.m
//  EagleChild
//
//  Created by Khang on 5/7/13.
//
//

#import "XCiteSharePopup.h"
#import <objc/runtime.h>
#import "AGWindowView.h"

@interface XCiteSharePopup()


@property (nonatomic, weak) IBOutlet UIButton *btnSend;
@property (nonatomic, weak) IBOutlet UIButton *btnCancel;
@property (nonatomic, strong) AGWindowView * agWindowView;

@end

@implementation XCiteSharePopup


#pragma mark - Initialize

+ (id)initPopupWithEmail:(NSString *)email
            completionBlock:(void (^)(NSInteger index, XCiteSharePopup * popupView))completionBlock
{
    XCiteSharePopup *popupView = [[self alloc] initWithNib];
    if (self == nil)
        return nil;
    
    //set block as an attribute in runtime
    if (completionBlock)
        objc_setAssociatedObject(popupView, "completionBlockCallback", [completionBlock copy], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [popupView setUpView];
    popupView.txtField.text = email;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [popupView.txtField becomeFirstResponder];
    });
    [popupView show];
    return popupView;
}

- (void)setUpView
{
    self.txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.txtField.placeholder attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#00a5db"]}];
}

#pragma mark - Actions

- (IBAction)onBtnGeneric:(UIButton *)sender
{
    //get back the block object attribute we set earlier
    void (^block)(NSInteger index, XCiteSharePopup * popupView) = objc_getAssociatedObject(self, "completionBlockCallback");
    if (block)
        block(sender.tag - 100, self);
}

@end
