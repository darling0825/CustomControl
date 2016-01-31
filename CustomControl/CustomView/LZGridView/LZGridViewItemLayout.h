//
//  LZGridViewItemLayout.h
//  CustomControl
//
//  Created by 沧海无际 on 14-9-27.
//  Copyright (c) 2014年 liww. All rights reserved.
//


#import <Cocoa/Cocoa.h>


/**
 `LZGridViewLayout` is a wrapper class containing all neccessary layout properties a `LZGridView` can adopt.
 */

@interface LZGridViewItemLayout : NSObject

/**
 The background color of the `CNGridViewItem`.
 
 You can set any known `NSColor` values, also pattern images. If this property is not used it will be set to the default value `[NSColor itemBackgroundColor]`. Also see NSColor(CNGridViewPalette).
 */
@property (nonatomic, strong) NSColor *backgroundColor;

/**
 The color of the selection ring.
 
 If this property is not used it will be set to the default value `[NSColor itemSelectionRingColor]`. Also see NSColor(CNGridViewPalette).
 */
@property (nonatomic, strong) NSColor *selectionRingColor;

/**
 ...
 */
@property (nonatomic, assign) CGFloat selectionRingLineWidth;

/**
 ...
 */
@property (nonatomic, assign) NSUInteger contentInset;

/**
 ...
 */
@property (nonatomic, assign) NSUInteger itemBorderRadius;

/**
 ...
 */
@property (strong) NSDictionary *itemTitleTextAttributes;


/** @name Creating Default Layouts */

/**
 Creates and returns an `CNGridViewItemLayout` object with default values.
 */
+ (LZGridViewItemLayout *)defaultLayout;
@end
