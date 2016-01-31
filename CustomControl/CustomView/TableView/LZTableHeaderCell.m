//
//  LZTableHeaderCell.m
//  CustomControl
//
//  Created by liww on 14-6-11.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "LZTableHeaderCell.h"

@implementation LZTableHeaderCell
@synthesize backgroundColor     = _bgColor;
@synthesize lineColor           = _lineColor;
@synthesize backgroundImage     = _backgroundImage;
@synthesize lineImage           = _lineImage;
@synthesize textAttribute       = _textAttribute;
@synthesize lastHeader          = _lastHeader;


- (id)initTextCell:(NSString *)aString
{
    self = [super initTextCell:aString];
    if (self) {
        
        //单行
        [self setUsesSingleLineMode:YES];
        
        //对齐
        [self setAlignment:NSLeftTextAlignment];
        
        //省略
        [self setLineBreakMode:NSLineBreakByTruncatingMiddle];
        
        _textAttribute = [[NSMutableDictionary alloc] init];
        //Align
        NSMutableParagraphStyle *ps = [[[NSParagraphStyle defaultParagraphStyle] mutableCopy] autorelease];
        [ps setAlignment:NSLeftTextAlignment];
        [_textAttribute setObject:ps forKey:NSParagraphStyleAttributeName];
        
        //Font name, size
        NSFont *font = [NSFont systemFontOfSize:13];
        [_textAttribute setObject:font forKey:NSFontAttributeName];
        
        //Color
        NSColor *color = [NSColor blackColor];
        [_textAttribute setObject:color forKey:NSForegroundColorAttributeName];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    LZTableHeaderCell *newCopy = [super copyWithZone:zone];
    newCopy->_backgroundImage = [_backgroundImage copyWithZone:zone];
    newCopy->_textAttribute = [_textAttribute copyWithZone:zone];
    
    return newCopy;
}

- (void)dealloc
{
    [_backgroundImage   release]; _backgroundImage  = nil;
    [_textAttribute     release]; _textAttribute    = nil;
    [super dealloc];
}

- (NSRect)_interiorCellFrameForFrame:(NSRect)frame
{
    NSRect result = frame;
    NSSize cellSize = [self cellSize];

    result.origin.x += (frame.size.width - cellSize.width)/2;
    result.origin.y += (frame.size.height - cellSize.height)/2 + 2;//位置误差+2
    result.size = cellSize;
    return result;
}

- (void)setHeaderFont:(NSFont *)font
{
    if (font) {
        [_textAttribute setObject:font forKey:NSFontAttributeName];
    }
}

- (void)setHeaderFontColor:(NSColor *)fontColor
{
    if (fontColor) {
        [_textAttribute setObject:fontColor forKey:NSForegroundColorAttributeName];
    }
}

- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    //Background Image
    if (_backgroundImage) {
        [_backgroundImage drawInRect:cellFrame
                            fromRect:NSZeroRect
                           operation:NSCompositeSourceOver
                            fraction:1.0];
    }
    else if (_bgColor){
        [_bgColor set];
        NSRectFill(cellFrame);
    }
    else{
        
    }
    
    //Line Image
    if (_lineImage && !_lastHeader) {
        NSRect lineRect = NSMakeRect(cellFrame.origin.x + cellFrame.size.width - _lineImage.size.width,
                                     cellFrame.origin.y,
                                     _lineImage.size.width,
                                     cellFrame.size.height);
		[_lineImage drawInRect:lineRect
                      fromRect:NSZeroRect
                     operation:NSCompositeSourceOver
                      fraction:1.0];
    }
    else if (_lineColor && !_lastHeader){
        NSRect lineRect = NSMakeRect(cellFrame.origin.x + cellFrame.size.width - 1,
                                     cellFrame.origin.y,
                                     1,
                                     cellFrame.size.height);
        [_lineColor set];
        NSRectFill(lineRect);
    }
    else{
        
    }
    
    //Title
    if (_textAttribute) {
        NSMutableAttributedString *attributeTitle = [[NSMutableAttributedString alloc] initWithAttributedString:[self attributedStringValue]];
        
        [attributeTitle addAttributes:_textAttribute
                                range:NSMakeRange(0, self.stringValue.length)];
        [self setAttributedStringValue:attributeTitle];
        [attributeTitle release]; attributeTitle = nil;
    }
    
    //Cell Position 默认:sortIndicator垂直居中 textField上对齐
    NSRect interiorCellFrame = [self _interiorCellFrameForFrame:cellFrame];
    [super drawInteriorWithFrame:interiorCellFrame inView:controlView];
}


@end
