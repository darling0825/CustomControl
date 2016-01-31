//
//  LZGridViewItem.h
//  CustomControl
//
//  Created by 沧海无际 on 14-9-27.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define TOOL_MARGIN_INSET   5.0
#define TOOL_TEXT_WIDTH     18.0

@class LZGridViewItemLayout;

APPKIT_EXTERN NSString* const kLZDefaultItemIdentifier;
#define CNItemIndexUndefined NSNotFound



#pragma mark - LZGridViewItemBase
@interface LZGridViewItemBase : NSViewController


#pragma mark - Reusing Grid View Items
/** @name Reusing Grid View Items */

/**
 ...
 */
@property (strong) NSString *reuseIdentifier;

/**
 ...
 */
@property (readonly, nonatomic) BOOL isReuseable;

/**
 ...
 */
- (void)prepareForReuse;

/**
 ...
 */
@property (assign) NSInteger index;

/**
 ...
 */
@property (assign) NSInteger section;

/**
 The object that the receiving item view represents 
 */
@property (assign) id representedItem;



#pragma mark - Selection and Hovering
/** @name Selection and Hovering */

/**
 ...
 */
@property (nonatomic, assign) BOOL selected;

/**
 ...
 */
@property (nonatomic, assign) BOOL selectable;

/**
 ...
 */
@property (nonatomic, assign) BOOL hovered;

/**
 ...
 */
+ (CGSize)defaultItemSize;

@end




#pragma mark - LZGridViewItem
@interface LZGridViewItem : LZGridViewItemBase

#pragma mark - Initialization
/** @name Initialization */

/**
 Creates and returns an initialized  This is the designated initializer.
 */
- (id)initWithLayout:(LZGridViewItemLayout *)layout reuseIdentifier:(NSString *)reuseIdentifier;

@property (nonatomic, assign) NSRect itemContentRect;

#pragma mark - Grid View Item Layout
/** @name Grid View Item Layout */

/**
 ...
 */
@property (nonatomic, strong) LZGridViewItemLayout *defaultLayout;

/** 
 ...
 */
@property (nonatomic, strong) LZGridViewItemLayout *hoverLayout;

/**
 ...
 */
@property (nonatomic, strong) LZGridViewItemLayout *selectionLayout;

/**
 ...
 */
@property (nonatomic, assign) BOOL useLayout;



@end
