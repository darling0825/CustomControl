//
//  NSColor+LZGridViewPalette.m
//  CustomControl
//
//  Created by 沧海无际 on 14-9-27.
//  Copyright (c) 2014年 liww. All rights reserved.
//


#import <Cocoa/Cocoa.h>

/**
 This is the standard `LZGridView` color palette. All colors can be overwritten by using the related properties of `LZGridView`
 or `CNGridViewItem`.
 */


@interface NSColor (LZGridViewPalette)


#pragma mark - GridView Item Colors


/** @name GridView Item Colors */

/** Returns the standard `LZGridViewItem` background color */
+ (NSColor *)itemBackgroundColor;
/** Returns the standard `LZGridViewItem` background color when the item is in mouse over state (property must be enabled) */
+ (NSColor *)itemBackgroundHoverColor;
/** Returns the standard `LZGridViewItem` background color when the item is selected */
+ (NSColor *)itemBackgroundSelectionColor;
/** Returns the standard `LZGridViewItem` selection ring color when the item is selected */
+ (NSColor *)itemSelectionRingColor;
+ (NSColor *)itemTitleColor;
+ (NSColor *)itemTitleShadowColor;
+ (NSColor *)selectionFrameColor;


#if __MAC_OS_X_VERSION_MAX_ALLOWED <= 1070
- (CGColorRef)CGColor;
+ (NSColor *)colorWithCGColor:(CGColorRef)CGColor;
#endif

@end
