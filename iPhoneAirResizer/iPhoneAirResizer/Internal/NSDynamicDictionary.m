//
//  NSDynamicDictionary.m
//
//  Created by アンドレ on H.22/03/21.
//  Copyright (c) 平成22年 アンドレ. All rights reserved.
//

#import "NSMutableString+Additions.h"
#import "NSDynamicDictionary.h"
#import <objc/runtime.h>

void dynamic_setter(id self, SEL _cmd, NSObject* theValue);
id dynamic_getter(id self, SEL _cmd);

@implementation NSDictionary (DynamicDictionary)

id dynamic_getter(NSObject *self, SEL _cmd) { 
	
	id returnValue = nil;
	NSString *method = NSStringFromSelector(_cmd);

    if ([method hasPrefix:@"_"]) {
        return nil;
    }
	
	if ((returnValue = [self valueForKey:method])) {
		return returnValue;
	}
		
    return returnValue;
}

void dynamic_setter(NSObject *self, SEL _cmd, NSObject* theValue) {
	
    NSMutableString *theKey = [NSMutableString stringWithString:NSStringFromSelector(_cmd)];
	if ([theKey hasPrefix:@"set"]) {
        
		[theKey deleteCharactersInRange:NSMakeRange(0, 3)];
		[theKey unCapitalizeString];
		
        if ([theKey hasSuffix:@":"]) {
			[theKey removeLastCharacter];
		}
				
		[self setValue:theValue forKey:theKey];
	}
}


+ (BOOL)resolveInstanceMethod:(SEL)aSEL {
	
    NSString *theMethod = NSStringFromSelector(aSEL);
    if ([theMethod hasPrefix:@"set"])  {
        class_addMethod(self.class,aSEL,(IMP)dynamic_setter,"v@:@");
        return YES;
    } else {
        class_addMethod(self.class,aSEL,(IMP)dynamic_getter,"@@:");
        return YES;
    }
	
    return [super resolveInstanceMethod:aSEL];
}
@end
