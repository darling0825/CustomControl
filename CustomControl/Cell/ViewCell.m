//
//  ImageTextCell.m
//  CustomControl
//
//  Created by 沧海无际 on 14-5-3.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "ViewCell.h"

@implementation ViewCell
@synthesize hidden = _hidden;

- (id)copyWithZone:(NSZone *)zone
{
    ViewCell *cell = [super copyWithZone:zone];
    if (cell != nil) {
        cell->_View = [_View retain];
    }
    return cell;
}

- (void)dealloc
{
    [_View release];   _View = nil;
    
    [super dealloc];
}

- (void)setCellView:(NSImageView*)cellView
{
    [cellView retain];
    [_View release]; _View = nil;
    _View = cellView;
}

//默认居中显示View
- (NSRect)_imageFrameForInteriorFrame:(NSRect)frame
{
    NSRect result = frame;
    
    return result;
}

- (NSRect)imageRectForBounds:(NSRect)frame
{
    return [self _imageFrameForInteriorFrame:frame];
}

- (void)drawInteriorWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    if (_hidden) {
        return;
    }
    
    if (_View) {
        NSRect imageFrame = [self _imageFrameForInteriorFrame:frame];
        [_View setFrame:imageFrame];
        if ([_View superview] != controlView) {
            [controlView addSubview:_View];
        }
    }
    
    [super drawInteriorWithFrame:frame inView:controlView];
}

@end
