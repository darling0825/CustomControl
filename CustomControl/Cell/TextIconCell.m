//
//  ImageTextCell.m
//  CustomControl
//
//  Created by 沧海无际 on 14-5-3.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "TextIconCell.h"

#define MARGIN_INSET    8.0

@implementation TextIconCell
@dynamic text;
@dynamic image;

- (id)init
{
    self = [super init];
    if (self) {
        [self setAlignment:NSLeftTextAlignment];
        [self setUsesSingleLineMode:YES];
        
        _textAttribute = [[NSMutableDictionary alloc] init];
        
        //Font name, size
        NSFont *font = [NSFont systemFontOfSize:13];
        [_textAttribute setObject:font forKey:NSFontAttributeName];
        
        //Color
        NSColor *color = [NSColor blackColor];
        [_textAttribute setObject:color forKey:NSForegroundColorAttributeName];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    TextIconCell *cell = [super copyWithZone:zone];
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

- (NSString *)text
{
    return [super stringValue];
}

- (NSImage *)image
{
    return _imageCell.image;
}

- (void)setText:(NSString *)text
{
    [self setStringValue:text];
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

- (NSRect)_textFrameForInteriorFrame:(NSRect)frame
{
    NSRect result = frame;
    NSSize cellSize = [self cellSize];
    result.origin.y += (result.size.height - cellSize.height)/2;
    
    NSRect imageFrame = [self _imageFrameForInteriorFrame:frame];
    result.origin.x += (imageFrame.size.width + MARGIN_INSET);
    
    result.size.width -= (imageFrame.size.width + MARGIN_INSET);
    return result;
}

- (NSRect)_imageFrameForInteriorFrame:(NSRect)frame
{
    NSRect result = frame;
    
    // Inset the top
    result.origin.y += MARGIN_INSET;
    result.size.height -= 2*MARGIN_INSET;
    
    // Inset the left
    //result.origin.x += MARGIN_INSET;
    result.size.width = result.size.height;
    
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
        [_imageCell drawWithFrame:imageFrame inView:controlView];
    }
    
    //Title
    if (_textAttribute) {
        NSMutableAttributedString *attributeTitle = [[NSMutableAttributedString alloc] initWithAttributedString:[self attributedStringValue]];
        [attributeTitle addAttributes:_textAttribute
                                range:NSMakeRange(0, self.stringValue.length)];
        [self setAttributedStringValue:attributeTitle];
        [attributeTitle release]; attributeTitle = nil;
    }
    
    NSRect textFrame = [self _textFrameForInteriorFrame:frame];
    [super drawInteriorWithFrame:textFrame inView:controlView];
}

- (NSUInteger)hitTestForEvent:(NSEvent *)event inRect:(NSRect)frame ofView:(NSView *)controlView
{
    NSPoint point = [controlView convertPoint:[event locationInWindow] fromView:nil];
    
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
