//
//  NSMutableString+Additions.h
//
//  Created by アンドレ on H.22/03/21.
//  Copyright (c) 平成22年 アンドレ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableString (NSStringAdditions)
- (void)removeLastCharacter;
- (void)unCapitalizeString;
@end


@interface NSString (NSStringAdditions)
- (NSString *)unCapitalizedString;
@end