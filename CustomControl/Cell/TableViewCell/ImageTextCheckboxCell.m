//
//  ImageTextCheckboxCell.m
//  CustomControl
//
//  Created by 沧海无际 on 14-5-3.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "ImageTextCheckboxCell.h"

#define MARGIN_INSET    4.0
#define CHECKBOX_WIDTH  18.0

@implementation ImageTextCheckboxCell

@dynamic image;
@dynamic name;
@dynamic selected;

- (id)init
{
    self = [super init];
    if (self) {
        [self setAlignment:NSCenterTextAlignment];
        
        //单行
        [self setUsesSingleLineMode:YES];
        
        //text中间省略号
        [self setLineBreakMode:NSLineBreakByTruncatingMiddle];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ImageTextCheckboxCell *cell = [super copyWithZone:zone];
    if (cell != nil) {
        // Retain or copy all our ivars
        cell->_imageCell = [_imageCell copyWithZone:zone];
        cell->_checkBoxCell = [_checkBoxCell copyWithZone:zone];
    }
    return cell;
}

- (void)dealloc
{
    [_imageCell     release];   _imageCell      = nil;
    [_checkBoxCell  release];   _checkBoxCell   = nil;
    
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

- (BOOL)isSelected
{
    return [_checkBoxCell state];
}

- (void)setSelected:(BOOL)isSelected
{
    if (_checkBoxCell == nil) {
        _checkBoxCell = [[NSButtonCell alloc] init];
        [_checkBoxCell setAllowsMixedState:NO];
        [_checkBoxCell setButtonType:NSSwitchButton];
        [_checkBoxCell setEditable:YES];
        [_checkBoxCell setSelectable:YES];
    }
    [_checkBoxCell setState:isSelected];
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

- (NSRect)_checkBoxFrameForInteriorFrame:(NSRect)frame
{
    NSRect result = frame;
    NSRect imageRect = [self _imageFrameForInteriorFrame:frame];
    
    // Move our inset to the left of the image frame
    result.origin.x = imageRect.origin.x + 2*MARGIN_INSET;
    
    // Go as wide as we can
    result.size.width = CHECKBOX_WIDTH;
    
    // Move the title above the Y centerline of the image.
    result.origin.y += 2*MARGIN_INSET + imageRect.size.height;
    
    NSSize naturalSize = [super cellSize];
    result.size.height = naturalSize.height;
    
    return result;
}

- (NSRect)_textFrameForInteriorFrame:(NSRect)frame
{
    NSRect result = frame;
    NSRect checkBoxRect = [self _checkBoxFrameForInteriorFrame:frame];
    NSRect imageRect = [self _imageFrameForInteriorFrame:frame];
    
    // Move our inset to the left of the image frame
    result.origin.x = checkBoxRect.origin.x + CHECKBOX_WIDTH + MARGIN_INSET;
    
    // Go as wide as we can
    result.size.width = imageRect.size.width - CHECKBOX_WIDTH -3*MARGIN_INSET;
    
    // Move the title above the Y centerline of the image.
    
    result.origin.y += 2*MARGIN_INSET + imageRect.size.height;
    
    NSSize naturalSize = [super cellSize];
    result.size.height = naturalSize.height;
    
    return result;
}

- (void)editWithFrame:(NSRect)aRect
               inView:(NSView *)controlView
               editor:(NSText *)textObj
             delegate:(id)anObject
                event:(NSEvent *)theEvent
{
    [super editWithFrame:[self titleRectForBounds:aRect]
                  inView:controlView
                  editor:textObj
                delegate:anObject
                   event:theEvent];
}

- (void)selectWithFrame:(NSRect)aRect
                 inView:(NSView *)controlView
                 editor:(NSText *)textObj
               delegate:(id)anObject
                  start:(NSInteger)selStart
                 length:(NSInteger)selLength
{
    [super selectWithFrame:[self titleRectForBounds:aRect]
                    inView:controlView
                    editor:textObj
                  delegate:anObject
                     start:selStart
                    length:selLength];
}

- (void)drawInteriorWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    if (_imageCell) {
        NSRect imageFrame = [self _imageFrameForInteriorFrame:frame];
        [_imageCell drawWithFrame:imageFrame inView:controlView];
    }
    
    if (_checkBoxCell) {
        NSRect checkBoxFrame = [self _checkBoxFrameForInteriorFrame:frame];
        [_checkBoxCell drawWithFrame:checkBoxFrame inView:controlView];
    }
    
    NSRect textFrame = [self _textFrameForInteriorFrame:frame];
    [super drawInteriorWithFrame:textFrame inView:controlView];
}

- (NSUInteger)hitTestForEvent:(NSEvent *)event
                       inRect:(NSRect)frame
                       ofView:(NSView *)controlView
{
    NSPoint point = [controlView convertPoint:[event locationInWindow] fromView:nil];
    
    // Delegate hit testing to other cells
    if (_imageCell) {
        NSRect imageFrame = [self _imageFrameForInteriorFrame:frame];
        if (NSPointInRect(point, imageFrame)) {
            return [_imageCell hitTestForEvent:event inRect:imageFrame ofView:controlView];
        }
    }
    
    if (_checkBoxCell) {
        NSRect checkBoxFrame = [self _checkBoxFrameForInteriorFrame:frame];
        if (NSPointInRect(point, checkBoxFrame)) {
            return [_checkBoxCell hitTestForEvent:event inRect:checkBoxFrame ofView:controlView];
        }
    }
    
    NSRect titleFrame = [self _textFrameForInteriorFrame:frame];
    if (NSPointInRect(point, titleFrame)) {
        return [super hitTestForEvent:event inRect:titleFrame ofView:controlView];
    }
    
    return NSCellHitNone;
}

+ (BOOL)prefersTrackingUntilMouseUp {
    // We want to have trackMouse:inRect:ofView:untilMouseUp: always track until the mouse is up
    return YES;
}

- (BOOL)trackMouse:(NSEvent *)theEvent
            inRect:(NSRect)frame
            ofView:(NSView *)controlView
      untilMouseUp:(BOOL)flag
{
    BOOL result = NO;
    NSRect checkBoxFrame = [self _checkBoxFrameForInteriorFrame:frame];
    NSPoint point1 = [controlView convertPoint:[theEvent locationInWindow]
                                      fromView:nil];
    
    if (NSPointInRect(point1, checkBoxFrame)) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CheckboxStateDidChanged
                                                            object:self
                                                          userInfo:nil];
        result = YES;
    }
    
    NSRect imageFrame = [self _imageFrameForInteriorFrame:frame];
    NSPoint point2 = [controlView convertPoint:[theEvent locationInWindow]
                                      fromView:nil];
    
    if (NSPointInRect(point2, imageFrame)) {
        
        if (theEvent.clickCount == 2){
            [[NSNotificationCenter defaultCenter] postNotificationName:DoubleClickImageDidFinish
                                                                object:self
                                                              userInfo:nil];
        }
        result = YES;
    }
    
    return result;
}

@end
