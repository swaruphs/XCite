//
//  NSObject+Additions.h
//
//  Created by Jesper Särnesjö on 2010-05-29.
//  Copyright 2010 Cartomapic. All rights reserved.
//

#import <Foundation/Foundation.h>

//Method swizzling
#define EXCHANGE_METHOD(a,b) [[self class]exchangeMethod:@selector(a) withNewMethod:@selector(b)]

#define STRING_ANALYTICS_CHILD_ID                   @"Child ID"
#define STRING_ANALYTICS_PARENT_ID                  @"Parent ID"
#define STRING_ANALYTICS_MODULE_ID                  @"Module ID"
#define STRING_ANALYTICS_DURATION                   @"Duration"
#define STRING_ANALYTICS_SESION_START               @"Session start"
#define STRING_ANALYTICS_SESION_END                 @"Session end"


@interface NSObject (Additions)

- (id)ifKindOfClass:(Class)c;

+ (void)exchangeMethod:(SEL)origSel withNewMethod:(SEL)newSel;

- (NSString *)getCurrentSSID;
- (BOOL)use3g;
- (BOOL) isValidObject;


#pragma mark - Social Helpers

- (BOOL)hasNativeFacebookApp;
- (BOOL)openFacebookPageID:(NSString*)pageID;
- (BOOL)hasNativeTwitterApp;
- (BOOL)openTwitterScreenName:(NSString*)screenName;

@end
