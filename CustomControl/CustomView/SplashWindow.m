//
//  SplashWindow.m
//  CustomControl
//
//  Created by 沧海无际 on 15-3-18.
//  Copyright (c) 2015年 liww. All rights reserved.
//

#import "SplashWindow.h"


@implementation SplashWindow

- (id)initWithSplashImage:(NSString*)imgfile
{
    NSRect screenRect = [[NSScreen mainScreen] frame]; // NSRect for screen
    
    NSImage *backgroundImage = [NSImage imageNamed:imgfile];
    NSSize size = [backgroundImage size];
    CGRect contentRect = CGRectMake(screenRect.size.width /2-size.width/2, screenRect.size.height/2-size.height/2, size.width, size.height);
    [self setBackgroundColor:[NSColor colorWithPatternImage:backgroundImage]];
    self = [super initWithContentRect:contentRect
                            styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered
                                defer:NO];
    [self orderFront:self];
    return self;
}

- (BOOL)acceptsMouseMovedEvents
{
    return NO;
}
@end

