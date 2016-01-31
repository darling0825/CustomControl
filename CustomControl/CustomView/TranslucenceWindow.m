//
//  TranslucenceWindow.m
//  Dr.Fone_For_Android(Mac)
//
//  Created by 沧海无际 on 15-3-23.
//  Copyright (c) 2015年 darlingcoder. All rights reserved.
//

#import "TranslucenceWindow.h"

@implementation TranslucenceWindow
@synthesize backgroundColor = _color;

- initWithContentRect:(NSRect)contentRect
            styleMask:(NSUInteger)aStyle
              backing:(NSBackingStoreType)bufferingType
                defer:(BOOL)flag;
{
    if ((self = [super initWithContentRect:contentRect
                                 styleMask:aStyle
                                   backing:NSBackingStoreBuffered
                                     defer:flag]) != nil) {
        
        [self setOpaque:NO];
        [self enableBlurForWindow:self];
    }
    
    return self;
}


-(void)enableBlurForWindow:(NSWindow *)window
{
    [self setBackgroundColor:_color];
    CGSConnection connection = CGSDefaultConnectionForThread();
    CGSSetWindowBackgroundBlurRadius(connection, [window windowNumber], 50);
}
@end
