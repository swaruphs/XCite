//
//  XCiteSharePopup.h
//  XCite
//
//  Created by Swarup on 26/9/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XCiteSharePopup : UIView

- (void)show;
- (void)dismiss;
- (void)showOnCompletion:(void(^)(void))completionBlock;
- (void)dismissOnCompletion:(void(^)(void))completionBlock;

+ (id)initPopupWithEmail:(NSString *)email
         completionBlock:(void (^)(NSInteger index, XCiteSharePopup * popupView))completionBlock;



@end
