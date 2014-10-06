//
//  XCiteSharePopup.h
//  XCite
//
//  Created by Swarup on 26/9/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCitePopupBaseView.h"

@interface XCiteSharePopup : XCitePopupBaseView

@property (nonatomic, weak) IBOutlet UITextField *txtField;

+ (id)initPopupWithEmail:(NSString *)email
         completionBlock:(void (^)(NSInteger index, XCiteSharePopup * popupView))completionBlock;



@end
