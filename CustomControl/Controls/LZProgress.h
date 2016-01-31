//
//  LZProgress.h
//  CustomControl
//
//  Created by System Administrator on 13-8-20.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define ProgressValueForCompleted   100.0
#define ProgressValueForFailed      -1.0

typedef enum{
    Horizontal,
    TopToBottom,
    BottomToTop
}ProgressType;

@interface LZProgress : NSView{
    double      _currentValue;      //当前值
    double      _minValue;          //最大值
    double      _maxValue;          //最小值
    
    NSImage     *_bgImage;          //背景图片
    NSImage     *_pgImage;          //进度条图片
    
    NSColor     *_bgColor;          //背景颜色
    NSColor     *_pgColor;          //进度条颜色
    
    BOOL        isSetBgImage;       //是否设置背景图片
    BOOL        isSetPgImage;       //是否设置进度条图片
    
    BOOL        _type;              //类型
}

- (void)setType:(ProgressType)type;

- (void)setProgressValue:(double)value;
- (void)setMinValue:(double)minValue;
- (void)setMaxValue:(double)maxValue;

- (void)setBackgroundImage:(NSImage *)img;
- (void)setProgressImage:(NSImage *)img;
- (void)setBackgroundColor:(NSColor *)color;
- (void)setProgressColor:(NSColor *)color;

- (double)progressValue;
- (double)minValue;
- (double)maxValue;

@end
