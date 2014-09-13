//
//  APPTestiPhoneUXViewController.m
//
//  Created by アンドレ on H26/05/03.
//  Copyright (c) 平成26年 アンドレ. All rights reserved.
//

#import "UIViewController+SubviewControllerTransition.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "APPTestiPhoneUXViewController.h"

@import AssetsLibrary;

@interface APPTestiPhoneUXViewController ()

@end

@implementation APPTestiPhoneUXViewController

@synthesize selectediPhone = _selectediPhone;
@synthesize wideScreen = _wideScreen;

- (NSArray *)sizes {
	return @[@{@"name": @"iPhone 4",@"size":@{@"height":@(480),@"width":@(320)}},@{@"name": @"iPhone 5",@"size":@{@"height":@(569),@"width":@(320)}},@{@"name": @"iPhone 6",@"size":@{@"height":@(667),@"width":@(375)}},@{@"name": @"iPhone 6+",@"size":@{@"height":@(736),@"width":@(414)}}];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStoryboard *storyBoard = nil;

	if (nil != self.hostViewControllerStoryboardName) {
		@try {
			storyBoard = [UIStoryboard storyboardWithName:self.hostViewControllerStoryboardName bundle:nil];
        } @catch(NSException *e) {NSLog(@"%@",e.description);}
    }
    
    if (nil != storyBoard) {
        self.hostStoryBoard = storyBoard;
        self.hostViewController = [storyBoard instantiateInitialViewController];
        [self showViewController:self.hostViewController inView:self.hostViewControllerContainer animated:YES completion:^(BOOL completed){
            self.selectediPhone = self.sizes[0];
        }];
    } else {
        UINib *nib = nil;
        
        if (nil != self.hostViewControllerNibName) {
            @try {
                
                nib = [UINib nibWithNibName:self.hostViewControllerNibName bundle:nil];
                if (nil != nib) {
                
                    self.hostNib = nib;
                    self.hostNibObjects = [self.hostNib instantiateWithOwner:UIApplication.sharedApplication.delegate options:nil];
                    
                    UIViewController *rootController = self.hostNibObjects[0];
                    if (![rootController isKindOfClass:UIViewController.class]) {
                    
                        for (UIWindow *window in self.hostNibObjects) {
                            if ([window isKindOfClass:UIWindow.class]) {
                                rootController = window.rootViewController;
                                window.rootViewController = self;
                            }
                        }
                    }
                    
                    self.hostViewController = rootController;
                }
            } @catch(NSException *e) {NSLog(@"%@",e.description);}
            
            if (nil != nib) {
                UIApplication.sharedApplication.delegate.window.rootViewController = self;
                [self showViewController:self.hostViewController inView:self.hostViewControllerContainer animated:YES completion:^(BOOL completed){
                    self.selectediPhone = self.sizes[0];
                }];
            }
        }
    }
}

- (void)setSelectediPhone:(NSObject<iPhone> *)selectediPhone {
	
	NSInteger selectedIndex = [self.sizes indexOfObject:selectediPhone];
	if (selectedIndex > -1) {
		
		if (self.iPhoneSelector.numberOfSegments > selectedIndex) {
			
			self.iPhoneSelector.selectedSegmentIndex = selectedIndex;
			
            BOOL wideScreen = self.wideScreen;
            CGFloat width = wideScreen ? selectediPhone.size.height.floatValue : selectediPhone.size.width.floatValue;
            CGFloat height = wideScreen ? selectediPhone.size.width.floatValue : selectediPhone.size.height.floatValue;
            
			[UIView animateWithDuration:0.55f animations:^{
				self.hostViewControllerHorizontalSizeConstraint.constant = width;
				self.hostViewControllerVerticalSizeConstraint.constant = height;
				
				[self.view setNeedsUpdateConstraints];
				[self.view layoutIfNeeded];
				
				self.phoneModelLabel.text = selectediPhone.name;
                
                self.phoneSizeLabel.text = [NSString stringWithFormat:@"%@x%@",selectediPhone.size.width,selectediPhone.size.height];
			}];
		}
	}
}

- (IBAction)setWideScreenWithSender:(UISwitch *)sender {
    self.wideScreen = sender.isOn;
}

- (void)setWideScreen:(BOOL)wideScreen {
    _wideScreen = wideScreen;
    self.selectediPhone = self.selectediPhone;
}

- (BOOL)wideScreen {
    return _wideScreen;
}

- (NSObject <iPhone> *)selectediPhone {
	NSInteger selectedIndex = self.iPhoneSelector.selectedSegmentIndex;
	if (self.sizes.count > selectedIndex) {
		return self.sizes[self.iPhoneSelector.selectedSegmentIndex];
	}
	return nil;
}

- (IBAction)setSelectediPhoneIndex:(UISegmentedControl *)sender {
	NSInteger selectedIndex = sender.selectedSegmentIndex;
	if (self.sizes.count > selectedIndex) {
		self.selectediPhone = self.sizes[sender.selectedSegmentIndex];
	}
}

- (IBAction)performSnapshot:(id)sender {
    UIView *viewToCapture = self.hostViewControllerContainer;
    if (nil != viewToCapture) {
        UIImage *sharingImage = nil;
        UIGraphicsBeginImageContextWithOptions(viewToCapture.frame.size, NO, 0.0);
        
        [viewToCapture.layer renderInContext:UIGraphicsGetCurrentContext()];
        sharingImage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();

        if (nil != sharingImage) {
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library saveImage:sharingImage toAlbum:@"iPhone Resizer Photos" withCompletionBlock:nil];
        }

    }
}

- (void)dealloc {
	NSLog(@"Deallocing");
}

@end
