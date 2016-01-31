//
//  LZTableHeaderCell.h
//  CustomControl
//
//  Created by liww on 14-6-11.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LZTableHeaderCell : NSTableHeaderCell{
    NSColor             *_bgColor;
    NSColor             *_lineColor;
    NSImage             *_backgroundImage;
    NSImage             *_lineImage;
    NSMutableDictionary *_textAttribute;
    BOOL                _lastHeader;
}
@property (copy)NSColor *backgroundColor;
@property (copy)NSColor *lineColor;
@property (copy)NSImage *backgroundImage;
@property (copy)NSImage *lineImage;
@property (retain)NSMutableDictionary *textAttribute;
@property (assign, getter = isLastHeader)BOOL lastHeader;

- (void)setHeaderFont:(NSFont *)font;

- (void)setHeaderFontColor:(NSColor *)fontColor;

@end
