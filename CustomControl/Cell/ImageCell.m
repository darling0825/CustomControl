//
//  ImageTextCell.m
//  CustomControl
//
//  Created by 沧海无际 on 14-5-3.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "ImageCell.h"

#define MARGIN_INSET    4.0

@implementation ImageCell
@dynamic image;

- (id)copyWithZone:(NSZone *)zone
{
    ImageCell *cell = [super copyWithZone:zone];
    if (cell != nil) {
        cell->_imageCell = [_imageCell copyWithZone:zone];
    }
    return cell;
}

- (void)dealloc
{
    [_imageCell release];   _imageCell = nil;
    
    [super dealloc];
}

- (NSImage *)image
{
    return _imageCell.image;
}

- (void)setImage:(NSImage *)image
{
    if (_imageCell == nil) {
        _imageCell = [[NSImageCell alloc] init];
        [_imageCell setControlView:self.controlView];
        [_imageCell setBackgroundStyle:self.backgroundStyle];
    }
    _imageCell.image = image;
}

- (void)setControlView:(NSView *)controlView
{
    [super setControlView:controlView];
    [_imageCell setControlView:controlView];
}

- (void)setBackgroundStyle:(NSBackgroundStyle)style
{
    [super setBackgroundStyle:style];
    [_imageCell setBackgroundStyle:style];
}

- (NSRect)_imageFrameForInteriorFrame:(NSRect)frame
{
    NSRect result = frame;
    /*
    // Inset the top
    result.origin.y += MARGIN_INSET;
    result.size.height += 2*MARGIN_INSET;
    
    // Inset the left
    result.origin.x += MARGIN_INSET;
    result.size.width += 2*MARGIN_INSET;
     */
    return result;
}

- (NSRect)imageRectForBounds:(NSRect)frame
{
    return [self _imageFrameForInteriorFrame:frame];
}

- (void)drawInteriorWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    if (_imageCell) {
        NSRect imageFrame = [self _imageFrameForInteriorFrame:frame];
        [_imageCell drawInteriorWithFrame:imageFrame inView:controlView];
    }
    else{
        //图片不能显示
        [super drawInteriorWithFrame:frame inView:controlView];
    }
}

- (NSUInteger)hitTestForEvent:(NSEvent *)event inRect:(NSRect)frame ofView:(NSView *)controlView
{
    NSPoint point = [controlView convertPoint:[event locationInWindow] fromView:nil];
    
    // Delegate hit testing to other cells
    if (_imageCell) {
        NSRect imageFrame = [self _imageFrameForInteriorFrame:frame];
        if (NSPointInRect(point, imageFrame)) {
            return [_imageCell hitTestForEvent:event inRect:imageFrame ofView:controlView];
        }
    }
    
    return NSCellHitNone;
}

@end
