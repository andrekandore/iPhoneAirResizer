//
//  UIViewUILayerAccessories.m
//  UIViewUILayerAccessories
//
//  Created by アンドレ on H.25/02/01.
//
//

#import <QuartzCore/QuartzCore.h>
#import "UIViewUILayerAccessories.h"

@implementation UIView (LayerAccessories)

- (void)setCornerRadius:(CGFloat)cornerRadius {
	self.layer.cornerRadius = (CGFloat)cornerRadius;
}

- (CGFloat)cornerRadius {
	return self.layer.cornerRadius;
}

- (void)setBorderColor:(UIColor *)borderColor {
	self.layer.borderColor = borderColor.CGColor;
}

- (UIColor *)borderColor {
	return [UIColor colorWithCGColor:self.layer.borderColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = (borderWidth < 1.0f ? (self.window.screen.scale < 2 ? 1.0f : borderWidth) : borderWidth);
}

- (CGFloat)borderWidth {
	return self.layer.borderWidth;
}

- (void)setShadowColor:(UIColor *)shadowColor {
	self.layer.shadowColor = shadowColor.CGColor;
}

- (UIColor *)shadowColor {
	return [UIColor colorWithCGColor:self.layer.shadowColor];
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
	self.layer.shadowOpacity = shadowOpacity;
}

- (CGFloat)shadowOpacity {
	return self.layer.shadowOpacity;
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
	self.layer.shadowRadius = shadowRadius;
}

- (CGFloat)shadowRadius {
	return self.layer.shadowRadius;
}

- (void)setShadowOffset:(CGSize)shadowOffset {
	self.layer.shadowOffset = shadowOffset;
}

- (CGSize)shadowOffset {
	return self.layer.shadowOffset;
}

@end