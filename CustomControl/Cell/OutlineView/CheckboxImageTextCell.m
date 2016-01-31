//
//  CheckboxImageTextCell.m
//  CustomControl
//
//  Created by 沧海无际 on 14-6-15.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "CheckboxImageTextCell.h"

#define MARGIN_INSET    2.0
#define CHECKBOX_WIDTH  18.0
#define IMAGE_WIDTH     18.0

@implementation CheckboxImageTextCell

@synthesize image       = _image;
@synthesize isEnable    = _isEnable;
@synthesize isHidden    = _isHidden;
@dynamic name;
@dynamic selected;

- (id)init
{
    self = [super init];
    if (self) {
        [self setAlignment:NSLeftTextAlignment];
        
        //单行
        [self setUsesSingleLineMode:YES];
        
        //text中间省略号
        [self setLineBreakMode:NSLineBreakByTruncatingMiddle];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    CheckboxImageTextCell *cell = [super copyWithZone:zone];
    if (cell != nil) {
        // Retain or copy all our ivars
        cell->_image = [_image copyWithZone:zone];
        cell->_checkBoxCell = [_checkBoxCell copyWithZone:zone];
    }
    return cell;
}

- (void)dealloc
{
    [_image         release];   _image          = nil;
    [_checkBoxCell  release];   _checkBoxCell   = nil;
    
    [super dealloc];
}

- (NSString *)name
{
    return self.title;
}

- (void)setName:(NSString *)name
{
    [self setTitle:name];
}

- (NSInteger)isSelected
{
    return [_checkBoxCell state];
}

- (void)setSelected:(NSInteger)isSelected
{
    if (_checkBoxCell == nil) {
        _checkBoxCell = [[NSButtonCell alloc] init];
        [_checkBoxCell setAllowsMixedState:YES];
        [_checkBoxCell setButtonType:NSSwitchButton];
        [_checkBoxCell setEditable:YES];
        [_checkBoxCell setSelectable:YES];
    }
    [_checkBoxCell setState:isSelected];
}

- (NSSize)_imageSize
{
    return NSMakeSize(16, 16);
}

- (NSRect)_checkBoxFrameForInteriorFrame:(NSRect)frame
{
    NSRect result = frame;
    
    if (_checkBoxCell) {
        result.size.width = CHECKBOX_WIDTH;
        result.size.height = CHECKBOX_WIDTH;
        result.origin.x += MARGIN_INSET;
        result.origin.y += ceil((frame.size.height - result.size.height) / 2);
    }
    else{
        result = NSZeroRect;
    }

    return result;
}

- (NSRect)imageRectForBounds:(NSRect)frame
{
    // We would apply any inset that here that drawWithFrame did before calling
    // drawInteriorWithFrame:. It does none, so we don't do anything.
    
    NSRect result = frame;
    NSRect checkBoxRect = [self _checkBoxFrameForInteriorFrame:frame];
    
    if (_image != nil) {
        result.size = [self _imageSize];
        result.origin.x = NSMaxX(checkBoxRect) + MARGIN_INSET;
        result.origin.y += ceil((frame.size.height - result.size.height) / 2);
    }
    else {
        result.size = NSZeroSize;
        result.origin.x = NSMaxX(checkBoxRect) + MARGIN_INSET;
        result.origin.y += ceil((frame.size.height - result.size.height) / 2);
    }
    return result;
}

//Cell Position 默认:textField垂直居中
- (NSRect)titleRectForBounds:(NSRect)frame
{
    NSRect result = frame;
    NSRect imageRect = [self imageRectForBounds:frame];
    result.origin.x = NSMaxX(imageRect) + MARGIN_INSET;
    result.size.width = NSMaxX(frame) - NSMinX(result);
    
    NSSize naturalSize = [super cellSize];
    result.origin.y += ceil((frame.size.height - naturalSize.height) / 2);
    result.size.height = naturalSize.height;
    return result;
}

//设置选中行高亮颜色时, 文字部分不是蓝色（ NSTableViewSelectionHighlightStyleRegular）
- (NSColor *)highlightColorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    return nil;
}

//drawInteriorWithFrame 与drawWithFrame相同
- (void)drawInteriorWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    if (_checkBoxCell) {
        NSRect checkBoxFrame = [self _checkBoxFrameForInteriorFrame:frame];
        [_checkBoxCell drawWithFrame:checkBoxFrame inView:controlView];
    }
    
    if (_image) {
        NSRect imageFrame = [self imageRectForBounds:frame];
        [_image drawInRect:imageFrame
                  fromRect:NSZeroRect
                 operation:NSCompositeSourceOver
                  fraction:1.0
            respectFlipped:YES
                     hints:nil];
    }
    
    NSRect textFrame = [self titleRectForBounds:frame];
    [super drawInteriorWithFrame:textFrame inView:controlView];
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

- (NSUInteger)hitTestForEvent:(NSEvent *)event
                       inRect:(NSRect)frame
                       ofView:(NSView *)controlView
{
    NSPoint point = [controlView convertPoint:[event locationInWindow] fromView:nil];
    
    // Delegate hit testing to other cells
    if (_image) {
        NSRect imageFrame = [self imageRectForBounds:frame];
        if (NSPointInRect(point, imageFrame)) {
            return NSCellHitContentArea;
        }
    }

    if (_checkBoxCell) {
        NSRect checkBoxFrame = [self _checkBoxFrameForInteriorFrame:frame];
        if (NSPointInRect(point, checkBoxFrame)) {
            return [_checkBoxCell hitTestForEvent:event inRect:checkBoxFrame ofView:controlView];
        }
    }
    
    NSRect titleFrame = [self titleRectForBounds:frame];
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
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CheckboxImageTextCellStateDidChanged
                                                            object:self
                                                          userInfo:nil];
        result = YES;
    }
    
    NSRect imageFrame = [self imageRectForBounds:frame];
    NSPoint point2 = [controlView convertPoint:[theEvent locationInWindow]
                                      fromView:nil];
    
    if (NSPointInRect(point2, imageFrame)) {
        
        if (theEvent.clickCount == 2){
            [[NSNotificationCenter defaultCenter] postNotificationName:DoubleClickCheckboxImageTextCellDidFinish
                                                                object:self
                                                              userInfo:nil];
        }
        result = YES;
    }
    
    return result;
}
@end
