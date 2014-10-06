//
//  XCiteJoinUsPopup.h
//  XCite
//
//  Created by Swarup on 3/10/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCitePopupBaseView.h"

@interface XCiteJoinUsPopup : XCitePopupBaseView

@property (nonatomic, weak) IBOutlet UITextField *txtEmail;
@property (nonatomic, weak) IBOutlet UITextField *txtFirstName;
@property (nonatomic, weak) IBOutlet UITextField *txtLastName;
@property (nonatomic, weak) IBOutlet UIView *titleViewHolder;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray *btnTitles;
@property (nonatomic, strong) UIButton *selectedBtn;

+ (instancetype)showPopupWithEmail:(NSString *)email  completionBlock:(void (^)(NSInteger index, XCiteJoinUsPopup * popupView))completionBlock;

@end
