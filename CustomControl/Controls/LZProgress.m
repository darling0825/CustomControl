//
//  LZProgress.m
//  CustomControl
//
//  Created by System Administrator on 13-8-20.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "LZProgress.h"

@interface LZProgress()
- (void)drawBackGround;
- (void)drawProgress;
- (NSImage *)cutImageFromImage:(NSImage *)srcImg rect:(NSRect)srcRect;
@end

@implementation LZProgress

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self config];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self config];
    }
    
    return self;
}

- (void)config
{
    isSetBgImage = NO;  //默认使用颜色作为背景
    isSetPgImage = NO;  //默认使用颜色作为进度显示
    
    _currentValue = 0;
    _minValue = 0;
    _maxValue = 1;
    
    _bgImage = [[NSImage alloc] initWithSize:NSZeroSize];
    _pgImage = [[NSImage alloc] initWithSize:NSZeroSize];
    _bgColor = [[NSColor alloc] init];
    _pgColor = [[NSColor alloc] init];
    
    //默认颜色
    [self setBackgroundColor:[NSColor lightGrayColor]];
    [self setProgressColor:[NSColor purpleColor]];
}

- (void)awakeFromNib
{
//    _bgImage = [NSImage imageNamed:@"progress_bgImage"];
//    _pgImage = [NSImage imageNamed:@"progress_pgImage"];
    
//    _bgColor = [NSColor lightGrayColor];
//    _pgColor = [NSColor purpleColor];
    
//    _bgColor = [[NSColor colorWithCalibratedRed:1.0 green:110/255.0 blue:38/255.0 alpha:1.0] retain];
//    _pgColor = [[NSColor colorWithCalibratedRed:200/255.0 green:1/255.0 blue:255/255.0 alpha:1.0] retain];
}

- (void)dealloc
{
    [_bgImage release]; _bgImage = nil;
    [_pgImage release]; _pgImage = nil;
    [_bgColor release]; _bgColor = nil;
    [_pgColor release]; _pgColor = nil;
    
    [super dealloc];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [self drawBackGround];
    [self drawProgress];

    [super drawRect:dirtyRect];
}

- (void)setType:(ProgressType)type
{
    _type = type;
}
#pragma mark ----------------Private method------------------
- (void)drawBackGround
{
    //设置了图片，优先使用图片
    if (isSetBgImage) 
    {
        NSSize imgSize = [_bgImage size];
        CGFloat endsLength;
        
        if (_type == Horizontal){
            if (imgSize.width < 100) {
                endsLength = ceil(imgSize.width / 2);
            }
            else if (imgSize.width < 200){
                endsLength = ceil(imgSize.width / 5);
            }
            else{
                endsLength = ceil(imgSize.width / 8);
            }
            
            NSImage *startCap = [self cutImageFromImage:_bgImage rect:NSMakeRect(0, 0, endsLength, imgSize.height)];
            NSImage *centerCap = [self cutImageFromImage:_bgImage rect:NSMakeRect(imgSize.width/2, 0, 1, imgSize.height)];
            NSImage *endCap = [self cutImageFromImage:_bgImage rect:NSMakeRect(imgSize.width-endsLength, 0, endsLength, imgSize.height)];
            
            CGFloat width = self.bounds.size.width;
            CGFloat height = self.bounds.size.height;
            NSRect drawRect = NSMakeRect(0, 0, width, height);
            
            NSDrawThreePartImage(drawRect, startCap, centerCap, endCap, NO, NSCompositeSourceOver, 1, NO);
        }
        else{
            if (imgSize.height < 100) {
                endsLength = ceil(imgSize.height / 2);
            }
            else if (imgSize.height < 200){
                endsLength = ceil(imgSize.height / 5);
            }
            else{
                endsLength = ceil(imgSize.height / 8);
            }
            
            //图片从上往下
            NSImage *start = [self cutImageFromImage:_bgImage rect:NSMakeRect(0, imgSize.height - endsLength, imgSize.width, endsLength)];
            NSImage *center = [self cutImageFromImage:_bgImage rect:NSMakeRect(0, imgSize.height/2, imgSize.width, 1)];
            NSImage *end = [self cutImageFromImage:_bgImage rect:NSMakeRect(0, 0, imgSize.width, endsLength)];
            
            CGFloat width = self.bounds.size.width;
            CGFloat height = self.bounds.size.height;
            NSRect drawRect = NSMakeRect(0, 0, width, height);
            
            NSDrawThreePartImage(drawRect, start, center, end, YES, NSCompositeSourceOver, 1, NO);
        }
    }
    else 
    {
        [_bgColor set];
        [NSBezierPath fillRect:self.bounds];
    }
}

- (void)drawProgress
{
    //设置了图片，优先使用图片
    if (isSetPgImage) {
        [self drawImageV2];
    }
    else {
        [self drawColor];
    }
}

- (void)drawImage
{
    NSSize imgSize = [_pgImage size];
    double totalLength = _maxValue - _minValue;
    CGFloat x;
    CGFloat y;
    CGFloat width;
    CGFloat height;
    
    CGFloat drawEndsLength = 0;
    CGFloat endsLength = 0;
    
    if (_type == TopToBottom) {
        width = self.bounds.size.width;
        height = self.bounds.size.height * (_currentValue /totalLength);
        x = 0;
        y = self.bounds.size.height - height;
        
        NSSize size = NSMakeSize(width, height);
        
        drawEndsLength = ceil(size.height/3);
        if (drawEndsLength >= 10) {
            drawEndsLength = 10;
        }
        
        endsLength = ceil(imgSize.height/3);
        if (endsLength >= 10) {
            endsLength = 10;
        }
        
        [_pgImage drawInRect:NSMakeRect(x, y + height-drawEndsLength, size.width, drawEndsLength)
                    fromRect:NSMakeRect(x, imgSize.height-endsLength, imgSize.width, endsLength)
                   operation:NSCompositeSourceOver
                    fraction:1];
        
        [_pgImage drawInRect:NSMakeRect(x, y + drawEndsLength, size.width, size.height-drawEndsLength*2)
                    fromRect:NSMakeRect(x, imgSize.height/2, imgSize.width, 1)
                   operation:NSCompositeSourceOver
                    fraction:1];
        
        [_pgImage drawInRect:NSMakeRect(0, y, size.width, drawEndsLength)
                    fromRect:NSMakeRect(0, 0, imgSize.width, endsLength)
                   operation:NSCompositeSourceOver
                    fraction:1];
        
    }
    else if (_type == BottomToTop){
        width = self.bounds.size.width;
        height = self.bounds.size.height * (_currentValue /totalLength);
        
        NSSize size = NSMakeSize(width, height);
        
        drawEndsLength = ceil(size.height/3);
        if (drawEndsLength >= 10) {
            drawEndsLength = 10;
        }
        
        endsLength = ceil(imgSize.height/3);
        if (endsLength >= 10) {
            endsLength = 10;
        }
        
        [_pgImage drawInRect:NSMakeRect(0, 0, size.width, drawEndsLength)
                    fromRect:NSMakeRect(0, 0, imgSize.width, endsLength)
                   operation:NSCompositeSourceOver
                    fraction:1];
        
        [_pgImage drawInRect:NSMakeRect(0, drawEndsLength, size.width, size.height-drawEndsLength*2)
                    fromRect:NSMakeRect(0, imgSize.height/2, imgSize.width, 1)
                   operation:NSCompositeSourceOver
                    fraction:1];
        
        [_pgImage drawInRect:NSMakeRect(0, size.height-drawEndsLength, size.width, drawEndsLength)
                    fromRect:NSMakeRect(0, imgSize.height-endsLength, imgSize.width, endsLength)
                   operation:NSCompositeSourceOver
                    fraction:1];

    }
    else{
        width = self.bounds.size.width * (_currentValue /totalLength);
        height = self.bounds.size.height;
        
        NSSize size = NSMakeSize(width, height);
        
        drawEndsLength = ceil(size.width/3);
        if (drawEndsLength >= 10) {
            drawEndsLength = 10;
        }
        
        endsLength = ceil(imgSize.width/3);
        if (endsLength >= 10) {
            endsLength = 10;
        }
        
        [_pgImage drawInRect:NSMakeRect(0, 0, drawEndsLength, size.height)
                    fromRect:NSMakeRect(0, 0, endsLength, imgSize.height)
                   operation:NSCompositeSourceOver
                    fraction:1];
        
        [_pgImage drawInRect:NSMakeRect(drawEndsLength, 0, size.width-drawEndsLength*2, size.height)
                    fromRect:NSMakeRect(imgSize.width/2, 0, 1, imgSize.height)
                   operation:NSCompositeSourceOver
                    fraction:1];
        
        [_pgImage drawInRect:NSMakeRect(size.width-drawEndsLength, 0, drawEndsLength, size.height)
                    fromRect:NSMakeRect(imgSize.width-endsLength, 0, endsLength, imgSize.height)
                   operation:NSCompositeSourceOver
                    fraction:1];
    }

}

- (void)drawImageV2
{
    NSSize imgSize = [_pgImage size];
    
    double totalLength = _maxValue - _minValue;
    CGFloat endsLength;
    CGFloat x;
    CGFloat y;
    CGFloat width;
    CGFloat height;
    NSImage *start = nil;
    NSImage *center = nil;
    NSImage *end = nil;
    
    BOOL isVertical = _type != Horizontal ? YES:NO;
    
    if (_type == TopToBottom) {
        endsLength = ceil(imgSize.height/3);
        if (endsLength >= 10) {
            endsLength = 10;
        }
        
        width = self.bounds.size.width;
        height = self.bounds.size.height * (_currentValue /totalLength);
        x = 0;
        y = self.bounds.size.height - height;
        
        //图片从上往下
        start = [self cutImageFromImage:_pgImage rect:NSMakeRect(0, imgSize.height - endsLength, imgSize.width, endsLength)];
        center = [self cutImageFromImage:_pgImage rect:NSMakeRect(0, imgSize.height/2, imgSize.width, 1)];
        end = [self cutImageFromImage:_pgImage rect:NSMakeRect(0, 0, imgSize.width, endsLength)];
    }
    else if (_type == BottomToTop){
        endsLength = ceil(imgSize.height/3);
        if (endsLength >= 10) {
            endsLength = 10;
        }
        
        width = self.bounds.size.width;
        height = self.bounds.size.height * (_currentValue /totalLength);
        x = 0; y = 0;
        
        //图片从上往下
        start = [self cutImageFromImage:_pgImage rect:NSMakeRect(0, imgSize.height-endsLength, imgSize.width, endsLength)];
        center = [self cutImageFromImage:_pgImage rect:NSMakeRect(0, imgSize.height/2, imgSize.width, 1)];
        end = [self cutImageFromImage:_pgImage rect:NSMakeRect(0, 0, imgSize.width, endsLength)];
    }
    else{
        endsLength = ceil(imgSize.width/3);
        if (endsLength >= 10) {
            endsLength = 10;
        }
        
        width = self.bounds.size.width * (_currentValue /totalLength);
        height = self.bounds.size.height;
        x = 0; y = 0;
        
        //图片从左往右
        start = [self cutImageFromImage:_pgImage rect:NSMakeRect(0, 0, endsLength, imgSize.height)];
        center = [self cutImageFromImage:_pgImage rect:NSMakeRect(imgSize.width/2, 0, 1, imgSize.height)];
        end = [self cutImageFromImage:_pgImage rect:NSMakeRect(imgSize.width-endsLength, 0, endsLength, imgSize.height)];
    }
    
    NSRect drawRect = NSMakeRect(x, y, width, height);
    NSDrawThreePartImage(drawRect, start, center, end, isVertical, NSCompositeSourceOver, 1, NO);
}

- (void)drawColor
{
    double totalLength = _maxValue - _minValue;
    CGFloat x;
    CGFloat y;
    CGFloat width;
    CGFloat height;
    
    if (_type == TopToBottom) {
        width = self.bounds.size.width;
        height = self.bounds.size.height * (_currentValue /totalLength);
        x = 0;
        y = self.bounds.size.height - height;
    }
    else if (_type == BottomToTop){
        width = self.bounds.size.width;
        height = self.bounds.size.height * (_currentValue /totalLength);
        x = 0; y = 0;
    }
    else{
        width = self.bounds.size.width * (_currentValue /totalLength);
        height = self.bounds.size.height;
        x = 0; y = 0;
    }
    NSRect drawRect = NSMakeRect(x, y, width, height);
    [_pgColor set];
    [NSBezierPath fillRect:drawRect];
}

- (NSImage *)cutImageFromImage:(NSImage *)srcImg rect:(NSRect)srcRect
{
    NSImage *dstImg = [[NSImage alloc]initWithSize:srcRect.size];
    NSRect dstRect = NSZeroRect; dstRect.size = srcRect.size;
    
    [dstImg lockFocus];
    [srcImg drawInRect:dstRect
              fromRect:srcRect 
             operation:NSCompositeSourceOver 
              fraction:1.0f
        respectFlipped:YES
                 hints:nil];
    
    [dstImg unlockFocus];
    
    return [dstImg autorelease];
}

#pragma mark ---------------Setter and Getter-----------------
- (void)setBackgroundImage:(NSImage *)img
{
    isSetBgImage = YES;
    [img retain];
    [_bgImage release];
    _bgImage = img;
}

- (void)setProgressImage:(NSImage *)img
{
    isSetPgImage = YES;
    [img retain];
    [_pgImage release];
    _pgImage = img;
}

- (void)setBackgroundColor:(NSColor *)color
{
    [color retain];
    [_bgColor release];
    _bgColor = color;
}

- (void)setProgressColor:(NSColor *)color
{
    [color retain];
    [_pgColor release];
    _pgColor = color;
}

- (void)setProgressValue:(double)value
{
    _currentValue = value;
    [self setNeedsDisplay:YES];
}

- (void)setMinValue:(double)minValue
{
    _minValue = minValue;
}

- (void)setMaxValue:(double)maxValue
{
    _maxValue = maxValue;
}

- (double)minValue
{
    return _minValue;
}

- (double)maxValue
{
    return _maxValue;
}

- (double)progressValue
{
    return _currentValue;
}

@end
