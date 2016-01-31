
//
//  LZGridViewItemLayout.h
//  CustomControl
//
//  Created by 沧海无际 on 14-9-27.
//  Copyright (c) 2014年 liww. All rights reserved.
//


#import "LZGridViewItemLayout.h"
#import "NSColor+CNGridViewPalette.h"

#if !__has_feature(objc_arc)
#error "Please use ARC for compiling this file."
#endif


static CGFloat kDefaultContentInset;
static CGFloat kDefaultSelectionRingLineWidth;
static CGFloat kDefaultItemBorderRadius;


@implementation LZGridViewItemLayout

+ (void)initialize {
	kDefaultSelectionRingLineWidth = 3.0f;
	kDefaultContentInset = 0.0f;
	kDefaultItemBorderRadius = 5.0f;
}

- (id)init {
	self = [super init];
	if (self) {
		_backgroundColor        = [NSColor itemBackgroundColor];
		_selectionRingColor     = [NSColor itemSelectionRingColor];
		_selectionRingLineWidth = kDefaultSelectionRingLineWidth;
		_contentInset           = kDefaultContentInset;
		_itemBorderRadius       = kDefaultItemBorderRadius;

		/// title text font attributes
		NSColor *textColor      = [NSColor itemTitleColor];
		NSShadow *textShadow    = [NSShadow new];
		[textShadow setShadowColor:[NSColor itemTitleShadowColor]];
		[textShadow setShadowOffset:NSMakeSize(0, -1)];

		NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
		[textStyle setAlignment:NSCenterTextAlignment];
        [textStyle setLineBreakMode:NSLineBreakByTruncatingMiddle];

        _itemTitleTextAttributes = @{NSFontAttributeName: [NSFont fontWithName:@"Helvetica" size:12],
                                     NSShadowAttributeName: textShadow,
                                     NSForegroundColorAttributeName: textColor,
                                     NSParagraphStyleAttributeName: textStyle};
    }
	return self;
}

+ (LZGridViewItemLayout *)defaultLayout {
	LZGridViewItemLayout *defaultLayout = [[[self class] alloc] init];
	return defaultLayout;
}

@end
