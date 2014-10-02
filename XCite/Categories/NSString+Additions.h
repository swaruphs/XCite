//
//  NSString+Additions.h
//  
//
//  Created by Daud Abas on 24/2/12.
//  Copyright (c) 2012 2359 Media Pte Ltd. All rights reserved.
//



@interface NSString (Additions)

- (NSString*)URLEncodedString;
- (NSString*)URLEncodeEverything;

- (NSString *)sha1;
- (NSString *)md5;
@end
