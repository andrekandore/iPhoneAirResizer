//
//  UIViewUILayerAccessories.h
//  UIViewUILayerAccessories
//
//  Created by アンドレ on H.25/02/01.
//
//

#import <UIKit/UIKit.h>

@interface UIView (LayerAccessories)
@property CGFloat cornerRadius;
@property CGFloat borderWidth;
@property UIColor *borderColor;
@property UIColor *shadowColor;
@property CGFloat shadowRadius;
@property CGFloat shadowOpacity;
@property CGSize shadowOffset;
@end
