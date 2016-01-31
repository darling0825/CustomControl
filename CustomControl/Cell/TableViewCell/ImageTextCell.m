//
//  ImageTextCell.m
//  CustomControl
//
//  Created by 沧海无际 on 14-5-3.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "ImageTextCell.h"
#define MARGIN_INSET    4.0

@implementation ImageTextCell

@dynamic image;
@dynamic name;

- (id)init
{
    self = [super init];
    if (self) {
        [self setAlignment:NSCenterTextAlignment];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ImageTextCell *cell = [super copyWithZone:zone];
    if (cell != nil) {
        // Retain or copy all our ivars
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

- (NSString *)name
{
    return self.title;
}

- (void)setName:(NSString *)name
{
    [self setTitle:name];
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
    
    NSSize size = [super cellSize];
    // Inset the top
    result.origin.y += MARGIN_INSET;
    result.size.height -= 3*MARGIN_INSET + size.height;
    
    // Inset the left
    result.origin.x += MARGIN_INSET;
    
    // Make the width match the aspect ratio based on the height
    result.size.width -= 2*MARGIN_INSET;
    return result;
}

- (NSRect)imageRectForBounds:(NSRect)frame
{
    // We would apply any inset that here that drawWithFrame did before calling
    // drawInteriorWithFrame:. It does none, so we don't do anything.
    return [self _imageFrameForInteriorFrame:frame];
}

- (NSRect)_textFrameForInteriorFrame:(NSRect)frame
{
    NSRect result = frame;
    
    // Move our inset to the left of the image frame
    result.origin.x += MARGIN_INSET;
    
    // Go as wide as we can
    result.size.width -= 2*MARGIN_INSET;
    
    // Move the title above the Y centerline of the image.
    NSRect imageRect = [self _imageFrameForInteriorFrame:frame];
    result.origin.y += 2*MARGIN_INSET + imageRect.size.height;
    
    NSSize naturalSize = [super cellSize];
    result.size.height = naturalSize.height;
    
    return result;
}

- (void)drawInteriorWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    if (_imageCell) {
        NSRect imageFrame = [self _imageFrameForInteriorFrame:frame];
        [_imageCell drawWithFrame:imageFrame inView:controlView];
    }
    
    NSRect textFrame = [self _textFrameForInteriorFrame:frame];
    [super drawInteriorWithFrame:textFrame inView:controlView];
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
    
    NSRect titleFrame = [self _textFrameForInteriorFrame:frame];
    if (NSPointInRect(point, titleFrame)) {
        return [super hitTestForEvent:event inRect:titleFrame ofView:controlView];
    }
    
    return NSCellHitNone;
}

@end
