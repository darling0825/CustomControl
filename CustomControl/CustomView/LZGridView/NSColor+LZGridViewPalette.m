//
//  NSColor+LZGridViewPalette.m
//  CustomControl
//
//  Created by 沧海无际 on 14-9-27.
//  Copyright (c) 2014年 liww. All rights reserved.
//


#import "NSColor+LZGridViewPalette.h"


#if !__has_feature(objc_arc)
#error "Please use ARC for compiling this file."
#endif


@implementation NSColor (LZGridViewPalette)


#pragma mark - LZGridView Item Default Colors

+ (NSColor *)itemBackgroundColor {
	return [NSColor colorWithCalibratedWhite:0.0 alpha:0.05];
}

+ (NSColor *)itemBackgroundHoverColor {
	return [NSColor colorWithCalibratedWhite:0.0 alpha:0.1];
}

+ (NSColor *)itemBackgroundSelectionColor {
	return [NSColor colorWithCalibratedWhite:0.000 alpha:0.250];
}

+ (NSColor *)itemSelectionRingColor {
	return [NSColor colorWithCalibratedRed:0.346 green:0.531 blue:0.792 alpha:1.000];
}

+ (NSColor *)itemTitleColor {
	return [NSColor colorWithDeviceRed:0.196 green:0.200 blue:0.200 alpha:1.000];
}

+ (NSColor *)itemTitleShadowColor {
	return [NSColor colorWithDeviceWhite:1.000 alpha:0.800];
}

+ (NSColor *)selectionFrameColor {
	return [NSColor grayColor];
}


#pragma mark - Generic Stuff


#if __MAC_OS_X_VERSION_MAX_ALLOWED <= 1070
/** found at: https://gist.github.com/707921 */
- (CGColorRef)CGColor {
	const NSInteger numberOfComponents = [self numberOfComponents];
	CGFloat components[numberOfComponents];
	CGColorSpaceRef colorSpace = [[self colorSpace] CGColorSpace];

	[self getComponents:(CGFloat *)&components];

	return (__bridge CGColorRef)(__bridge id)CGColorCreate(colorSpace, components);
}

/** found at: https://gist.github.com/707921 */
+ (NSColor *)colorWithCGColor:(CGColorRef)CGColor {
	if (CGColor == NULL) return nil;
	return [NSColor colorWithCIColor:[CIColor colorWithCGColor:CGColor]];
}

#endif

@end
