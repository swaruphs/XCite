//
//  XCitePopupBaseView.h
//  XCite
//
//  Created by Swarup on 4/10/14.
//  Copyright (c) 2014 2359 Media. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XCitePopupBaseView : UIView

- (id)initWithNib;
- (void)show;
- (void)dismiss;
- (void)showOnCompletion:(void(^)(void))completionBlock;
- (void)dismissOnCompletion:(void(^)(void))completionBlock;


@end
