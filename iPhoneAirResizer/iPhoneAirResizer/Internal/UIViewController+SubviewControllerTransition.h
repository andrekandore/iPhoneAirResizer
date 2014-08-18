//
//  UIViewController+SubviewControllerTransition.h
//
//  Created by アンドレ on H26/05/03.
//  Copyright (c) 平成26年 アンドレ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (ViewControllers)
- (void)showViewController:(UIViewController *)controller inView:(UIView *)parentView animated:(BOOL)animated completion:(void(^)(BOOL))completionBlock;
- (void)removeViewController:(UIViewController *)controller completion:(void(^)(void))completion;
@end
