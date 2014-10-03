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
    popupView.txtField.text = email;
    [popupView show];
    return popupView;
}



#pragma mark - Initialization helpers

- (id)initWithNib
{
    NSString *className = NSStringFromClass([self class]);
    return [self initWithNibName:className];
}

- (id)initWithNibName:(NSString *)nibName
{
    self = [super init];
    if (self == nil)
        return nil;
    self = [[[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil] objectAtIndex:0];
    return self;
}

- (void)awakeFromNib
{
    UIFont *btnFont = [UIFont fontWithName:@"RockwellStd" size:24];
    self.btnCancel.titleLabel.font = btnFont;
    self.btnSend.titleLabel.font = btnFont;
}

#pragma mark - Public interfaces

- (void)show
{
    [self showOnCompletion:nil];
}

- (void)dismiss
{
    [self dismissOnCompletion:nil];
}

- (void)showOnCompletion:(void(^)(void))completionBlock
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onKeyboardWillShowNotification:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onKeyboardWillHideNotification:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.agWindowView = [[AGWindowView alloc] initAndAddToKeyWindow];
    [self.agWindowView addSubview:self];
    
    self.center = [self getWindowCenter];
    self.alpha = 0;
    self.layer.transform = CATransform3DMakeScale(0.8, 0.8, 0.8);
    
    [UIView mt_animateViews:@[self]
                   duration:0.5
             timingFunction:kMTEaseOutElastic
                    options:UIViewAnimationOptionBeginFromCurrentState
                 animations:^{
                     self.alpha = 1;
                     self.layer.transform = CATransform3DIdentity;
                 } completion:^{
                     
                     //Optional
                  
                 }];
    
    [UIView animateWithDuration:0.4 animations:^{
        self.agWindowView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    } completion:^(BOOL finished) {
        if (completionBlock)
            completionBlock();
    }];
}

- (void)dismissOnCompletion:(void(^)(void))completionBlock
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
   
    
    [UIView mt_animateViews:@[self]
                   duration:0.6
             timingFunction:kMTEaseInElastic
                    options:UIViewAnimationOptionBeginFromCurrentState
                 animations:^{
                     self.alpha = 0;
                     self.layer.transform = CATransform3DMakeScale(0.6, 0.6, 0.6);
                 } completion:^{
                     
                 }];
    
    double delayInSeconds = 0.2;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.agWindowView fadeOutAndRemoveFromSuperview:completionBlock];
    });
}

#pragma mark - Private helpers


- (CGPoint)getWindowCenter
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    if (IOS8_OR_ABOVE) {
        return CGPointMake(CGRectGetMidX(screenRect), CGRectGetMidY(screenRect));
    }
    if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation))
        return CGPointMake(CGRectGetMidX(screenRect), CGRectGetMidY(screenRect));
    
    return CGPointMake(CGRectGetMidY(screenRect), CGRectGetMidX(screenRect));
}



#pragma mark - Keyboard hanlding

/*
 * This is needed because iOS always return keyboard size in landscape orientation
 */
- (CGFloat)getCorrectKeyboardHeight:(CGSize)originalSize
{
    return MIN(originalSize.height, originalSize.width);
}

/*
 * This is needed because iOS always return keyboard size in landscape orientation
 */
- (CGFloat)getCorrectKeyboardWidth:(CGSize)originalSize
{
    return MAX(originalSize.height, originalSize.width);
}

- (CGRect)currentScreenBoundsDependOnOrientation
{
    CGRect screenBounds = [UIScreen mainScreen].bounds ;
    CGFloat width = CGRectGetWidth(screenBounds)  ;
    CGFloat height = CGRectGetHeight(screenBounds) ;
    UIInterfaceOrientation interfaceOrientation = [UIApplication sharedApplication].statusBarOrientation;
    
    if (IOS8_OR_ABOVE) {
        screenBounds.size = CGSizeMake(width, height);
    }
    else if (UIInterfaceOrientationIsPortrait(interfaceOrientation))         screenBounds.size = CGSizeMake(width, height);
    else if (UIInterfaceOrientationIsLandscape(interfaceOrientation))   screenBounds.size = CGSizeMake(height, width);
    
    return screenBounds ;
}

- (void)onKeyboardWillShowNotification:(NSNotification *)sender
{
    CGSize kbSize = [[[sender userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    CGFloat kbHeight = [self getCorrectKeyboardHeight:kbSize];
    CGFloat availableHeight = CGRectGetHeight([self currentScreenBoundsDependOnOrientation]) - kbHeight;
    
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions animationCurve = [[[sender userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGPoint center = self.center;
    center.y = availableHeight / 2 - 10;
    
    //Adjust tableView or scrollView inset
    [UIView animateWithDuration:duration delay:0 options:animationCurve animations:^{
        self.center = center;
    } completion:^(BOOL finished) {
    }];
}

- (void)onKeyboardWillHideNotification:(NSNotification *)sender
{
    NSTimeInterval duration = [[[sender userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationOptions animationCurve = [[[sender userInfo] objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    CGRect screenBounds = [self currentScreenBoundsDependOnOrientation];
    CGPoint center = CGPointMake(CGRectGetWidth(screenBounds)/2, CGRectGetHeight(screenBounds)/2);
    
    [UIView animateWithDuration:duration delay:0 options:animationCurve animations:^{
        self.center = center;
    } completion:^(BOOL finished) {
        
    }];
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
