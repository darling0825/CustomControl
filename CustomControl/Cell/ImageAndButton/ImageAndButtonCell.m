//
//  ImageTextCell.m
//  CustomControl
//
//  Created by 沧海无际 on 14-5-3.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "ImageAndButtonCell.h"

#define MARGIN_INSET    2.0
#define IMAGE_WIDTH     40.0
#define ClickSubFuncDidFinish       @"ClickSubFuncDidFinish"

@implementation ImageAndButtonCell

@dynamic image;
@dynamic name;

- (id)init
{
    self = [super init];
    if (self) {
        [self setAlignment:NSLeftTextAlignment];
        [self setBordered:NO];
        [self setEditable:NO];
        [self setSelectable:NO];
        [self setBezeled:YES];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    ImageAndButtonCell *cell = [super copyWithZone:zone];
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

- (double)cellHeight
{
    //NSSize size = NSMakeSize(CELL_WIDTH,IMAGE_WIDTH + 2*MARGIN_INSET);
    return IMAGE_WIDTH + 2*MARGIN_INSET;
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
    self.title = name;
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

//58 * 58
- (NSRect)_imageFrameForInteriorFrame:(NSRect)frame
{
    NSRect result = frame;
    
    result.size.width = IMAGE_WIDTH;
    result.size.height = IMAGE_WIDTH;
    
    result.origin.x += MARGIN_INSET;
    result.origin.y += MARGIN_INSET;

    return result;
}

- (NSRect)imageRectForBounds:(NSRect)frame
{
    // We would apply any inset that here that drawWithFrame did before calling
    // drawInteriorWithFrame:. It does none, so we don't do anything.
    return [self _imageFrameForInteriorFrame:frame];
}

- (NSRect)_titleFrameForInteriorFrame:(NSRect)frame
{
    NSRect result = frame;
    result.origin.x += IMAGE_WIDTH + 2*MARGIN_INSET;
    result.origin.y += MARGIN_INSET;

    return result;
}

- (void)drawInteriorWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    if (_imageCell) {
        NSRect imageFrame = [self _imageFrameForInteriorFrame:frame];
        [_imageCell drawWithFrame:imageFrame inView:controlView];
    }
    
    NSRect textFrame = [self _titleFrameForInteriorFrame:frame];
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
    
    NSRect titleFrame = [self _titleFrameForInteriorFrame:frame];
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
    
    NSPoint point = [controlView convertPoint:[theEvent locationInWindow]
                                     fromView:nil];
    
    if (NSPointInRect(point, frame)) {
        
        if (theEvent.clickCount == 1){
            //Method 1
//            [[NSNotificationCenter defaultCenter] postNotificationName:ClickSubFuncDidFinish
//                                                                object:self
//                                                              userInfo:nil];
            //Method 2 This method essentially highlights the button
            //[self performClick:nil];
        }
        else if (theEvent.clickCount == 2){
            
        }
        result = YES;
    }
    
    return result;
}
@end
