//
//  NSView+LZGridView.m
//  CustomControl
//
//  Created by 沧海无际 on 14-9-27.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "NSView+LZGridView.h"


#if !__has_feature(objc_arc)
#error "Please use ARC for compiling this file."
#endif


@implementation NSView (LZGridView)

- (BOOL)isSubviewOfView:(NSView *)theView {
	__block BOOL isSubView = NO;
	[[theView subviews] enumerateObjectsUsingBlock: ^(NSView *aView, NSUInteger idx, BOOL *stop) {
	    if ([self isEqualTo:aView]) {
	        isSubView = YES;
	        *stop = YES;
		}
	}];
	return isSubView;
}

- (BOOL)containsSubView:(NSView *)subview {
	__block BOOL containsSubView = NO;
	[[self subviews] enumerateObjectsUsingBlock: ^(NSView *aView, NSUInteger idx, BOOL *stop) {
	    if ([subview isEqualTo:aView]) {
	        containsSubView = YES;
	        *stop = YES;
		}
	}];
	return containsSubView;
}

@end
