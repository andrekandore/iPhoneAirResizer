//
//  NSMutableString+Additions.h
//
//  Created by アンドレ on H.22/03/21.
//  Copyright (c) 平成22年 アンドレ. All rights reserved.
//

#import "NSMutableString+Additions.h"

@implementation NSMutableString (NewstepNSStringAdditions)

- (void)removeLastCharacter { 
	if (self.length > 0) {
		[self deleteCharactersInRange:NSMakeRange(self.length-1, 1)];
	}
}

- (void)unCapitalizeString {
	
	NSString *uncapitalizedString = self;
	
	if (self.length > 0) {
		NSString *lowerCasePart = [[self substringToIndex:1] lowercaseString];
		NSString *upperCasePart = [self substringFromIndex:1];
		
		uncapitalizedString = [lowerCasePart stringByAppendingString:upperCasePart];
	}
	
	[self setString:uncapitalizedString];
}

@end

@implementation NSString (NSStringAdditions)

- (NSString *)unCapitalizedString {
    
    NSString *uncapitalizedString = self;
    
    if (self.length > 0) {
        NSString *lowerCasePart = [[self substringToIndex:1] lowercaseString];
        NSString *upperCasePart = [self substringFromIndex:1];
        
        uncapitalizedString = [lowerCasePart stringByAppendingString:upperCasePart];
    }
    
    return uncapitalizedString;
}

@end