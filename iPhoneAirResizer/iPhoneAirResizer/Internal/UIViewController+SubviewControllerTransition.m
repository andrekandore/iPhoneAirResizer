//
//  UIViewController+SubviewControllerTransition.m
//
//  Created by アンドレ on H26/05/03.
//  Copyright (c) 平成26年 アンドレ. All rights reserved.
//

#import "UIViewController+SubviewControllerTransition.h"

@implementation UIViewController (ViewControllers)

- (void)showViewController:(UIViewController *)controller inView:(UIView *)parentView animated:(BOOL)animated completion:(void(^)(BOOL))completionBlock {

    if (nil != controller) {
        
        CGRect parentBounds = parentView.bounds;
        CGPoint parentCenter = CGPointMake(parentBounds.size.width/2.0f, parentBounds.size.height/2.0f);
        
        controller.view.bounds = parentBounds;
        controller.view.center = parentCenter;
        
        [self addChildViewController:controller];
        
        if (!self.shouldAutomaticallyForwardAppearanceMethods) {
            [controller beginAppearanceTransition:YES animated:YES];
        }
        
        void(^addController)(void) = ^{
            if (animated) {
                
                CATransition *fadeInTransition = [[CATransition alloc]init];
                fadeInTransition.duration = .35f;
                
                [parentView.layer addAnimation:fadeInTransition forKey:@"fadeInTransition"];
                
            }
            [parentView addSubview:controller.view];
        };
        
        void(^completion)(BOOL) = ^(BOOL finished) {
            if (!self.shouldAutomaticallyForwardAppearanceMethods) {
                [controller endAppearanceTransition];
            }
            if (nil != completionBlock) {
                completionBlock(finished);
            }
        };
        
        if (animated) {
            [UIView animateWithDuration:.35f delay:0 options: UIViewAnimationOptionLayoutSubviews animations:addController completion:completion];
        } else {
            addController();
            completion(YES);
        }
        
    }
}


- (void)removeViewController:(UIViewController *)controller completion:(void(^)(void))completion {
    if (nil != controller) {
        
        [UIView animateWithDuration:.35f delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            CATransition *fadeOutTransition = [[CATransition alloc]init];
            fadeOutTransition.duration = .45f;
            
            [self.view.layer addAnimation:fadeOutTransition forKey:@"fadeOutTransition"];
            [controller willMoveToParentViewController:nil];
            [controller.view removeFromSuperview];
            
        } completion:^(BOOL finished) {
            
            [controller removeFromParentViewController];
            
            if (nil != completion) {
                completion();
            }
        }];
        
    }
}


@end