//
//  SplashWindowTest.m
//  CustomControl
//
//  Created by 沧海无际 on 15-3-18.
//  Copyright (c) 2015年 liww. All rights reserved.
//

#import "SplashWindowTest.h"
#import "SplashWindow.h"

@interface SplashWindowTest ()

@end

@implementation SplashWindowTest

- (id)init
{
    self = [super initWithWindowNibName:@"SplashWindowTest"];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    self.window = [[SplashWindow alloc] initWithSplashImage:@"IMG_0202"];
    
    // hide the about box after one second.
    [NSTimer scheduledTimerWithTimeInterval:2.0f
                                     target:self
                                   selector:@selector(closeSplashBox:)
                                   userInfo:self
                                    repeats:false];
}

- (void)closeSplashBox:(NSTimer*)theTimer
{
    [self.window close];
}

@end
