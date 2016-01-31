//
//  LZGridViewItem.m
//  CustomControl
//
//  Created by 沧海无际 on 14-9-27.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "LZGridViewItem.h"
#import "NSColor+LZGridViewPalette.h"
#import "LZGridViewItemLayout.h"


#if !__has_feature(objc_arc)
#error "Please use ARC for compiling this file."
#endif


NSString *const kLZDefaultItemIdentifier = @"LZGridViewItem";

/// Notifications
extern NSString *LZGridViewSelectAllItemsNotification;
extern NSString *LZGridViewDeSelectAllItemsNotification;

@implementation LZGridViewItemBase

+ (CGSize)defaultItemSize
{
	return NSMakeSize(80, 80);
}

- (void)dealloc
{

}

- (id)init
{
	self = [super init];
	if (self) {
		[self initProperties];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self initProperties];
	}
	return self;
}

- (void)initProperties
{
	/// Reusing Grid View Items
	self.reuseIdentifier = kLZDefaultItemIdentifier;
	self.index = CNItemIndexUndefined;

    //    /// Selection and Hovering
    //    _selected = NO;
    //    _selectable = YES;
    //    _hovered = NO;

}

- (void)prepareForReuse
{
	self.index = CNItemIndexUndefined;
	self.selected = NO;
	self.selectable = YES;
	self.hovered = NO;
}

- (BOOL)isReuseable
{
	return (self.selected ? NO : YES);
}

- (void)selectAll:(NSNotification *)notification
{
	[self setSelected:YES];
}

- (void)deSelectAll:(NSNotification *)notification
{
	[self setSelected:NO];
}

@end


@interface LZGridViewItem ()
@property (strong) LZGridViewItemLayout *currentLayout;
@end

@implementation LZGridViewItem

#pragma mark - Initialzation

- (id)initWithLayout:(LZGridViewItemLayout *)layout reuseIdentifier:(NSString *)reuseIdentifier {
	self = [self init];
	if (self) {
		_defaultLayout = layout;
		_hoverLayout = layout;
		_selectionLayout = layout;
		_currentLayout = _defaultLayout;
		self.reuseIdentifier = reuseIdentifier;
	}
	return self;
}

- (void)initProperties {
	[super initProperties];
    
	/// Grid View Item Layout
	_defaultLayout = [LZGridViewItemLayout defaultLayout];
	_hoverLayout = [LZGridViewItemLayout defaultLayout];
	_selectionLayout = [LZGridViewItemLayout defaultLayout];
	_currentLayout = _defaultLayout;
	_useLayout = YES;
}

- (BOOL)isFlipped {
	return YES;
}

#pragma mark - Reusing Grid View Items

- (void)prepareForReuse {
	[super prepareForReuse];
}

#pragma mark - Notifications

- (void)clearHovering {
	[self setHovered:NO];
}

- (void)clearSelection {
	[self setSelected:NO];
}

#pragma mark - Accessors

- (void)setHovered:(BOOL)hovered {
	[super setHovered:hovered];
	_currentLayout = (self.hovered ? _hoverLayout : (self.selected ? _selectionLayout : _defaultLayout));
	[self.view setNeedsDisplay:YES];
}

- (void)setSelected:(BOOL)selected {
	[super setSelected:selected];
	_currentLayout = (self.selected ? _selectionLayout : _defaultLayout);
	[self.view setNeedsDisplay:YES];
}

- (void)setDefaultLayout:(LZGridViewItemLayout *)defaultLayout {
	_defaultLayout = defaultLayout;
	self.currentLayout = _defaultLayout;
}

@end
