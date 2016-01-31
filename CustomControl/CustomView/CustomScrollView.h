//
//  CustomScrollView.h.h
//  CustomControl
//
//  Created by 沧海无际 on 14-5-1.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LZEdgeInsets.h"

typedef enum{
    BackgroundDrawType_None,
    BackgroundDrawType_Horizontal,
    BackgroundDrawType_Vertical,
    BackgroundDrawType_NinePart
}BackgroundDrawType;

@interface CustomScrollView : NSScrollView{
    NSColor                 *_color;
    NSImage                 *_image;
    NSImage                 *_stretchImage;
    BackgroundDrawType      _drawType;
    BOOL                    _stretchable;
    LZEdgeInsets            _edgeInsets;
}
@property (copy)NSColor *backgroundColor;
@property (copy)NSImage *backgroundImage;
@property (copy)NSImage *stretchBackgroundImage;
@property (assign)BackgroundDrawType drawType;
/**
 1.backgroundImage是否拉伸
 2.DrawType_NinePart四角是否拉伸
 */
@property(nonatomic, getter = isStretchable)BOOL stretchable;
@property (assign)LZEdgeInsets edgeInsets;
@end
