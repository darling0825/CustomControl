//
//  LZColorCenter.m
//  CustomControl
//
//  Created by liww on 15-10-31.
//  Copyright (c) 2015年 liww. All rights reserved.
//

#import "LZColorCenter.h"

#define NormalizeColor(x) ((x)/255.0)
#define MakeRGBAColor(r,g,b,a) [NSColor colorWithCalibratedRed:NormalizeColor(r) green:NormalizeColor(g) blue:NormalizeColor(b) alpha:a]

@implementation LZColorCenter
+ (NSColor *)bluePlainTextColor
{
    return MakeRGBAColor(88, 150, 219, 1.0);
}

+ (NSColor *)blueBackgroundColor
{
    return MakeRGBAColor(217, 235, 255, 1.0);
}

+ (NSColor *)blueBackgroundColor2
{
    return MakeRGBAColor(12, 105, 255, 1.0);
}

@end
