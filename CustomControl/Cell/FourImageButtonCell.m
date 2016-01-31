//
//  FourImageButtonCell.m
//  CustomControl
//
//  Created by 沧海无际 on 14-5-3.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "FourImageButtonCell.h"

@implementation FourImageButtonCell

@dynamic firstImage;
@dynamic secondImage;
@dynamic thirdImage;
@synthesize fourthImage;
@synthesize hidden = _hidden;

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
    FourImageButtonCell *cell = [super copyWithZone:zone];
    if (cell != nil) {
        // Retain or copy all our ivars
        cell->_buttonCell_1 = [_buttonCell_1 copyWithZone:zone];
        cell->_buttonCell_2 = [_buttonCell_2 copyWithZone:zone];
        cell->_buttonCell_3 = [_buttonCell_3 copyWithZone:zone];
        cell->_buttonCell_4 = [_buttonCell_4 copyWithZone:zone];
        cell->_targetObj = [_targetObj retain];
    }
    return cell;
}

- (void)dealloc
{
    [_buttonCell_1     release];   _buttonCell_1      = nil;
    [_buttonCell_2     release];   _buttonCell_2      = nil;
    [_buttonCell_3     release];   _buttonCell_3      = nil;
    [_buttonCell_4     release];   _buttonCell_4      = nil;
    
    [super dealloc];
}


- (NSImage *)firstImage
{
    return _buttonCell_1.image;
}

- (void)setFirstImage:(NSImage *)image
{
    if (_buttonCell_1 == nil) {
        _buttonCell_1 = [[NSImageCell alloc] init];
        [_buttonCell_1 setControlView:self.controlView];
        [_buttonCell_1 setBackgroundStyle:self.backgroundStyle];
    }
    _buttonCell_1.image = image;
}

- (NSImage *)secondImage
{
    return _buttonCell_2.image;
}

- (void)setSecondImage:(NSImage *)image
{
    if (_buttonCell_2 == nil) {
        _buttonCell_2 = [[NSImageCell alloc] init];
        [_buttonCell_2 setControlView:self.controlView];
        [_buttonCell_2 setBackgroundStyle:self.backgroundStyle];
    }
    _buttonCell_2.image = image;
}

- (NSImage *)thirdImage
{
    return _buttonCell_3.image;
}

- (void)setThirdImage:(NSImage *)image
{
    if (_buttonCell_3 == nil) {
        _buttonCell_3 = [[NSImageCell alloc] init];
        [_buttonCell_3 setControlView:self.controlView];
        [_buttonCell_3 setBackgroundStyle:self.backgroundStyle];
    }
    _buttonCell_3.image = image;
}

- (NSImage *)fourthImage
{
    return _buttonCell_4.image;
}

- (void)setFourthImage:(NSImage *)image
{
    if (_buttonCell_4 == nil) {
        _buttonCell_4 = [[NSImageCell alloc] init];
        [_buttonCell_4 setControlView:self.controlView];
        [_buttonCell_4 setBackgroundStyle:self.backgroundStyle];
    }
    _buttonCell_4.image = image;
}

- (void)setTarget:(id)anObject
{
    [anObject retain];
    [_targetObj release]; _targetObj = nil;
    _targetObj = anObject;
}

- (void)setFirstSelector:(SEL)sel
{
    _selector_1 = sel;
}
- (void)setSecondSelector:(SEL)sel
{
    _selector_2 = sel;
}
- (void)setThirdSelector:(SEL)sel
{
    _selector_3 = sel;
}
- (void)setFourthSelector:(SEL)sel
{
    _selector_4 = sel;
}

- (NSRect)_firstImageFrameForInteriorFrame:(NSRect)frame
{
    NSRect result = frame;
    
    result.size.height -= 2*MARGIN_DISTANCE;
    result.size.width = result.size.height;
    
    result.origin.y += MARGIN_DISTANCE;
    
    CGFloat dis = (frame.size.width - 4*result.size.width)/5.0;
    result.origin.x += 1*dis + (1-1)*result.size.width;
    
    return result;
}

- (NSRect)_secondImageFrameForInteriorFrame:(NSRect)frame
{
    NSRect result = frame;
    
    result.size.height -= 2*MARGIN_DISTANCE;
    result.size.width = result.size.height;
    
    result.origin.y += MARGIN_DISTANCE;
    
    CGFloat dis = (frame.size.width - 4*result.size.width)/5.0;
    result.origin.x += 2*dis + (2-1)*result.size.width;
    
    return result;
}

- (NSRect)_thirdImageFrameForInteriorFrame:(NSRect)frame
{
    NSRect result = frame;
    
    result.size.height -= 2*MARGIN_DISTANCE;
    result.size.width = result.size.height;
    
    result.origin.y += MARGIN_DISTANCE;
    
    CGFloat dis = (frame.size.width - 4*result.size.width)/5.0;
    result.origin.x += 3*dis + (3-1)*result.size.width;
    
    return result;
}

- (NSRect)_fourthImageFrameForInteriorFrame:(NSRect)frame
{
    NSRect result = frame;
    
    result.size.height -= 2*MARGIN_DISTANCE;
    result.size.width = result.size.height;
    
    result.origin.y += MARGIN_DISTANCE;
    
    CGFloat dis = (frame.size.width - 4*result.size.width)/5.0;
    result.origin.x += 4*dis + (4-1)*result.size.width;
    
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
    if (_hidden) {
        return;
    }
    
    if (_buttonCell_1) {
        NSRect imageFrame = [self _firstImageFrameForInteriorFrame:frame];
        [_buttonCell_1 drawWithFrame:imageFrame inView:controlView];
    }
    
    if (_buttonCell_2) {
        NSRect imageFrame = [self _secondImageFrameForInteriorFrame:frame];
        [_buttonCell_2 drawWithFrame:imageFrame inView:controlView];
    }
    
    if (_buttonCell_3) {
        NSRect imageFrame = [self _thirdImageFrameForInteriorFrame:frame];
        [_buttonCell_3 drawWithFrame:imageFrame inView:controlView];
    }
    
    if (_buttonCell_4) {
        NSRect imageFrame = [self _fourthImageFrameForInteriorFrame:frame];
        [_buttonCell_4 drawWithFrame:imageFrame inView:controlView];
    }
    
    //[super drawInteriorWithFrame:frame inView:controlView];
}

- (NSUInteger)hitTestForEvent:(NSEvent *)event
                       inRect:(NSRect)frame
                       ofView:(NSView *)controlView
{
    NSPoint point = [controlView convertPoint:[event locationInWindow] fromView:nil];
    
    // Delegate hit testing to other cells
    if (_buttonCell_1) {
        NSRect firstImageFrame = [self _firstImageFrameForInteriorFrame:frame];
        if (NSPointInRect(point, firstImageFrame)) {
            return [_buttonCell_1 hitTestForEvent:event inRect:firstImageFrame ofView:controlView];
        }
    }
    
    if (_buttonCell_2) {
        NSRect secondImageFrame = [self _secondImageFrameForInteriorFrame:frame];
        if (NSPointInRect(point, secondImageFrame)) {
            return [_buttonCell_2 hitTestForEvent:event inRect:secondImageFrame ofView:controlView];
        }
    }
    
    if (_buttonCell_3) {
        NSRect thirdImageFrame = [self _thirdImageFrameForInteriorFrame:frame];
        if (NSPointInRect(point, thirdImageFrame)) {
            return [_buttonCell_3 hitTestForEvent:event inRect:thirdImageFrame ofView:controlView];
        }
    }
    
    if (_buttonCell_4) {
        NSRect fourthImageFrame = [self _fourthImageFrameForInteriorFrame:frame];
        if (NSPointInRect(point, fourthImageFrame)) {
            return [_buttonCell_4 hitTestForEvent:event inRect:fourthImageFrame ofView:controlView];
        }
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
    
    NSRect firstImageFrame = [self _firstImageFrameForInteriorFrame:frame];
    NSPoint firstPoint = [controlView convertPoint:[theEvent locationInWindow]
                                      fromView:nil];
    if (NSPointInRect(firstPoint, firstImageFrame)) {
        [_targetObj performSelector:_selector_1];
        result = YES;
    }
    
    
    NSRect secondImageFrame = [self _secondImageFrameForInteriorFrame:frame];
    NSPoint secondPoint = [controlView convertPoint:[theEvent locationInWindow]
                                          fromView:nil];
    if (NSPointInRect(secondPoint, secondImageFrame)) {
        [_targetObj performSelector:_selector_2];
        result = YES;
    }
    
    
    NSRect thirdImageFrame = [self _thirdImageFrameForInteriorFrame:frame];
    NSPoint thirdPoint = [controlView convertPoint:[theEvent locationInWindow]
                                          fromView:nil];
    if (NSPointInRect(thirdPoint, thirdImageFrame)) {
        [_targetObj performSelector:_selector_3];
        result = YES;
    }
    
    
    NSRect fourthImageFrame = [self _fourthImageFrameForInteriorFrame:frame];
    NSPoint fourthPoint = [controlView convertPoint:[theEvent locationInWindow]
                                          fromView:nil];
    if (NSPointInRect(fourthPoint, fourthImageFrame)) {
        [_targetObj performSelector:_selector_4];
        result = YES;
    }
    
    return result;
}

@end
