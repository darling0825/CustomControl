//
//  CustomWindow.m
//  CustomControl
//
//  Created by 沧海无际 on 14-5-2.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "CustomWindow.h"

@implementation CustomWindow
/*
- (id)initWithContentRect:(NSRect)contentRect
                styleMask:(NSUInteger)windowStyle
                  backing:(NSBackingStoreType)bufferingType
                    defer:(BOOL)deferCreation
{
//    self = [super initWithContentRect:contentRect
//                            styleMask:NSBorderlessWindowMask
//                              backing:bufferingType
//                                defer:YES];
    

    self = [super initWithContentRect: contentRect
                            styleMask: NSBorderlessWindowMask
                              backing: NSBackingStoreBuffered
                                defer: NO];
    
    if (self != nil) {
        [self setLevel:NSNormalWindowLevel];
        //[self setBackgroundColor:[NSColor clearColor]];
        [self setOpaque:NO];
        [self setMovableByWindowBackground:YES];
    }
    
    return self;
}
*/
- (void)awakeFromNib
{
    [self setMovableByWindowBackground:YES];
}

- (void)makeContentViewFillWindow:(BOOL)iskeepWindowSize
{
    /* 2015-07-11
     当iskeepWindowSize == NO时:
     Window Size 和 Minimum Size 都是ContentView的大小
     如果设置了窗口的最小值Minimum Size, 那么整个窗口最小值最终就是（MinimumSize.Width,MinimumSize.Height + 22)
     */
    
    
    NSView *themeView = [[[self contentView] superview] retain];
    NSView *oldContentView = [[self contentView] retain];
    NSButton *closeBtn = [[self standardWindowButton:NSWindowCloseButton] retain];
    NSButton *miniBtn = [[self standardWindowButton:NSWindowMiniaturizeButton] retain];
    NSButton *zoomBtn = [[self standardWindowButton:NSWindowZoomButton] retain];
    
    if (oldContentView) {
        //替换是为了在setFrame时，不改变contentView的frame
        NSView *newContentView = [[NSView alloc] initWithFrame:oldContentView.frame];
        [self setContentView:newContentView];
        [newContentView release]; newContentView = nil;
        
        //Sheet窗口会改变
        //oldContentView.autoresizingMask = NSViewNotSizable;
        oldContentView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
        
        if (iskeepWindowSize) {
            //拉高contentView
            oldContentView.frame = themeView.frame;
        }
        else{
            //降低window自身
            [self setFrame:NSMakeRect(NSMinX(self.frame), NSMinY(self.frame), NSWidth(oldContentView.frame), NSHeight(oldContentView.frame))
                   display:NO];
        }
        
        //将原contentView添加到改变后的窗口上
        [themeView addSubview:oldContentView];
        
        if (closeBtn) {
            [closeBtn removeFromSuperview];
            [themeView addSubview:closeBtn];
        }
        
        if (miniBtn) {
            [miniBtn removeFromSuperview];
            [themeView addSubview:miniBtn];
        }
        
        if (zoomBtn) {
            [zoomBtn removeFromSuperview];
            [themeView addSubview:zoomBtn];
        }
    }
    
    [zoomBtn release]; zoomBtn = nil;
    [miniBtn release]; miniBtn = nil;
    [closeBtn release]; closeBtn = nil;
    [oldContentView release]; oldContentView = nil;
    [themeView release]; themeView = nil;
}
@end
