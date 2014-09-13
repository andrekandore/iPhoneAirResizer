//
//  APPTestiPhoneUXViewController.h
//
//  Created by アンドレ on H26/05/03.
//  Copyright (c) 平成26年 アンドレ. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol iPhoneSize <NSObject>
@property NSNumber *height;
@property NSNumber *width;
@end

@protocol iPhone <NSObject>
@property NSObject <iPhoneSize> *size;
@property NSString *name;
@end

@protocol IndexedSizes <NSObject>
- (NSObject <iPhone>*)objectAtIndexedSubscript:(NSUInteger)idx;
@end

@interface APPTestiPhoneUXViewController : UIViewController

@property IBOutlet NSLayoutConstraint *hostViewControllerHorizontalSizeConstraint;
@property IBOutlet NSLayoutConstraint *hostViewControllerVerticalSizeConstraint;

@property IBOutlet UIView *hostViewControllerContainer;
@property UIViewController *hostViewController;

@property NSString *hostViewControllerStoryboardName;
@property UIStoryboard *hostStoryBoard;

@property NSString *hostViewControllerNibName;
@property NSArray *hostNibObjects;
@property UINib *hostNib;


- (IBAction)setSelectediPhoneIndex:(UISegmentedControl *)sender;
@property IBOutlet UISegmentedControl *iPhoneSelector;
@property (readonly) NSArray <IndexedSizes> *sizes;
@property NSObject <iPhone> *selectediPhone;

@property (weak) IBOutlet UILabel *phoneModelLabel;
@property (weak) IBOutlet UILabel *phoneSizeLabel;

@property (weak, nonatomic) IBOutlet UIView *snapshotOverlay;

@property (weak, nonatomic) IBOutlet UISwitch *animateResizeSwitch;
- (IBAction)setAnimateResizeWithSender:(UISwitch *)sender;
@property BOOL animateResize;

@property (weak, nonatomic) IBOutlet UISwitch *widescreenSwitch;
- (IBAction)setWideScreenWithSender:(UISwitch *)sender;
@property BOOL wideScreen;

@property (weak, nonatomic) IBOutlet UISwitch *snapshotAllSizesSwitch;
- (IBAction)setSnapshotAllSizesWithSender:(UISwitch *)sender;
@property BOOL snapshotAllSizes;

@property (weak, nonatomic) IBOutlet UISwitch *snapshotWithBorderSwitch;
- (IBAction)setSnapshotWithBorderWithSender:(UISwitch *)sender;
@property BOOL snapshotWithBorder;

@end
