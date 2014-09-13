//
//  APPTestiPhoneUXViewController.m
//
//  Created by アンドレ on H26/05/03.
//  Copyright (c) 平成26年 アンドレ. All rights reserved.
//

#import "UIViewController+SubviewControllerTransition.h"
#import "ALAssetsLibrary+CustomPhotoAlbum.h"
#import "APPTestiPhoneUXViewController.h"
#import "NSMutableString+Additions.h"
#import "UIViewUILayerAccessories.h"
#import "Application+Convenience.h"

@import AssetsLibrary;

@interface APPTestiPhoneUXViewController ()
@property UIColor *currentViewToCaptureBorderColor;
@property CGFloat currentViewToCaptureBorderWidth;
@end

@implementation APPTestiPhoneUXViewController

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
                    [self syncronizeState];
                }];
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self syncronizeState];
}

- (void)syncronizeState {
    self.snapshotWithBorder = self.snapshotWithBorder;
    self.snapshotAllSizes = self.snapshotAllSizes;
    self.selectediPhone = self.selectediPhone;
    self.animateResize = self.animateResize;
    self.wideScreen = self.wideScreen;
}

- (NSString *)setterFromSelector:(SEL)selector {
    NSString *selectorString = NSStringFromSelector(selector);
    
    NSAssert(selectorString.length > 5, @"Setter Must Have Signature Longer than at Least 5 Characters, e.g. setA:");

    selectorString = [selectorString substringWithRange:NSMakeRange(3, selectorString.length-4)].unCapitalizedString;
    return selectorString;
}

- (NSString *)getterFromSelector:(SEL)selector {
    NSString *selectorString = NSStringFromSelector(selector);
    return selectorString;
}

- (void)setObject:(id)object toUserDefaultsWithSelector:(SEL)selector {
    [NSUserDefaults.standardUserDefaults setObject:object forKey:[self setterFromSelector:selector]];
}

- (id)objectfromUserDefaultsWithSelector:(SEL)selector {
    return [NSUserDefaults.standardUserDefaults objectForKey:[self getterFromSelector:selector]];
}

- (void)setSelectediPhone:(NSObject<iPhone> *)selectediPhone {
    NSInteger selectedIndex = [self.sizes indexOfObject:selectediPhone];
    if (selectedIndex > -1) {
        
        if (self.iPhoneSelector.numberOfSegments > selectedIndex) {
            
            [self setObject:selectediPhone toUserDefaultsWithSelector:_cmd];
            self.iPhoneSelector.selectedSegmentIndex = selectedIndex;
            
            BOOL wideScreen = self.wideScreen;
            CGFloat width = wideScreen ? selectediPhone.size.height.floatValue : selectediPhone.size.width.floatValue;
            CGFloat height = wideScreen ? selectediPhone.size.width.floatValue : selectediPhone.size.height.floatValue;
            
            void (^updateUI)(void) = ^{
                self.hostViewControllerHorizontalSizeConstraint.constant = width;
                self.hostViewControllerVerticalSizeConstraint.constant = height;
                
                [self.view setNeedsUpdateConstraints];
                [self.view layoutIfNeeded];
                
                self.phoneModelLabel.text = selectediPhone.name;
                
                self.phoneSizeLabel.text = [NSString stringWithFormat:@"%@x%@",selectediPhone.size.width,selectediPhone.size.height];
            };
            
            if (self.animateResize) {
                [UIView animateWithDuration:0.55f animations:updateUI];
            } else {
                updateUI();
            }
        }
    }
}

- (NSObject <iPhone> *)selectediPhone {
    return [self objectfromUserDefaultsWithSelector:_cmd];
}

- (IBAction)setSelectediPhoneIndex:(UISegmentedControl *)sender {
    NSInteger selectedIndex = sender.selectedSegmentIndex;
    if (self.sizes.count > selectedIndex) {
        self.selectediPhone = self.sizes[sender.selectedSegmentIndex];
    }
}

- (IBAction)setWideScreenWithSender:(UISwitch *)sender {
    self.wideScreen = sender.isOn;
}

- (void)setWideScreen:(BOOL)wideScreen {
    [self setObject:@(wideScreen) toUserDefaultsWithSelector:_cmd];
    self.selectediPhone = self.selectediPhone;
    self.widescreenSwitch.on = wideScreen;
}

- (BOOL)wideScreen {
    return [[self objectfromUserDefaultsWithSelector:_cmd] boolValue];
}


- (IBAction)setAnimateResizeWithSender:(UISwitch *)sender {
    self.animateResize = sender.isOn;
}

- (void)setAnimateResize:(BOOL)animateResize {
    [self setObject:@(animateResize) toUserDefaultsWithSelector:_cmd];
    self.animateResizeSwitch.on = animateResize;
}

- (BOOL)animateResize {
    return [[self objectfromUserDefaultsWithSelector:_cmd] boolValue];
}


- (IBAction)setSnapshotAllSizesWithSender:(UISwitch *)sender {
    self.snapshotAllSizes = sender.on;
}

- (void)setSnapshotAllSizes:(BOOL)snapshotAllSizes {
    [self setObject:@(snapshotAllSizes) toUserDefaultsWithSelector:_cmd];
    self.snapshotAllSizesSwitch.on = snapshotAllSizes;
}

- (BOOL)snapshotAllSizes {
    return [[self objectfromUserDefaultsWithSelector:_cmd] boolValue];
}


- (IBAction)setSnapshotWithBorderWithSender:(UISwitch *)sender {
    self.snapshotWithBorder = sender.on;
}

- (void)setSnapshotWithBorder:(BOOL)snapshotWithBorder {
    
    UIView *viewToCapture = self.hostViewControllerContainer;
    if (nil != viewToCapture) {
        if (!snapshotWithBorder) {
            self.currentViewToCaptureBorderWidth = viewToCapture.borderWidth;
            self.currentViewToCaptureBorderColor = viewToCapture.borderColor;
            viewToCapture.borderColor = UIColor.clearColor;
            viewToCapture.borderWidth = 0;
        } else {
            if (nil != self.currentViewToCaptureBorderColor) {
                viewToCapture.borderColor = self.currentViewToCaptureBorderColor;
                viewToCapture.borderWidth = self.currentViewToCaptureBorderWidth;
            }
        }
    }
    
    [self setObject:@(snapshotWithBorder) toUserDefaultsWithSelector:_cmd];
    self.snapshotWithBorderSwitch.on = snapshotWithBorder;
}

- (BOOL)snapshotWithBorder {
    return [[self objectfromUserDefaultsWithSelector:_cmd] boolValue];
}

- (IBAction)performSnapshot:(id)sender {
    UIView *viewToCapture = self.hostViewControllerContainer;
    if (nil != viewToCapture) {
        
        if (self.snapshotAllSizes) {
            NSObject <iPhone> *currentPhone = self.selectediPhone;

            [self performSnapshotOfView:viewToCapture forSizeAtIndex:0 inSizes:self.sizes.copy completion:^{
                self.selectediPhone = currentPhone;
            }];
            
        } else {
            [self captureView:viewToCapture andSaveToAlbumNamed:@"iPhone Resizer Photos" withCompletionBlock:^(NSError *error){
                [self flashCapture:nil];
            }];
        }
        

    }
}

- (void)performSnapshotOfView:(UIView *)viewToCapture forSizeAtIndex:(NSUInteger)currentIndex inSizes:(NSArray <IndexedSizes>*)sizes completion:(voidBlock)completion {
    if (currentIndex < sizes.count) {
        
        self.selectediPhone = sizes[currentIndex];
        
        [self captureView:viewToCapture andSaveToAlbumNamed:@"iPhone Resizer Photos" withCompletionBlock:^(NSError *error){
            [self flashCapture:^(BOOL completed){
                [self performSnapshotOfView:viewToCapture forSizeAtIndex:currentIndex+1 inSizes:sizes completion:completion];
            }];
        }];

    } else {
        if (nil != completion) {
            completion();
        }
    }
}

- (void)captureView:(UIView *)view andSaveToAlbumNamed:(NSString *)name withCompletionBlock:(SaveImageCompletion)completionBlock{
    UIImage *sharingImage = nil;
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    sharingImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    if (nil != sharingImage) {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library saveImage:sharingImage toAlbum:name withCompletionBlock:completionBlock];
    }
}

- (void)flashCapture:(boolBlock)completion {
    UIView *flashView = self.snapshotOverlay;
    if (nil != flashView) {
        [UIView animateWithDuration:0.1f animations:^{
            flashView.alpha = 1.0f;
        } completion:^(BOOL complete) {
            if (complete) {
                [UIView animateWithDuration:1.0f animations:^{
                    flashView.alpha = 0.0;
                } completion:completion];
            }
        }];
    }
}

- (void)dealloc {
	NSLog(@"Deallocing");
}

@end
