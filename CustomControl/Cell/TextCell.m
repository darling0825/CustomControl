//
//  DateAndTypeCell.m
//  CustomControl
//
//  Created by 沧海无际 on 7/30/14.
//  Copyright (c) 2014 liww. All rights reserved.
//

#import "TextCell.h"

@implementation TextCell
@synthesize selected;
@dynamic text;


- (id)init
{
    self = [super init];
    if (self) {
        [self setAlignment:NSLeftTextAlignment];
        [self setUsesSingleLineMode:YES];
        
//        _textAttribute = [[NSMutableDictionary alloc] init];
//        
//        //Font name, size
//        NSFont *font = [NSFont systemFontOfSize:13];
//        [_textAttribute setObject:font forKey:NSFontAttributeName];
//        
//        //Color
//        NSColor *color = [NSColor colorWithDeviceRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1.0];
//        [_textAttribute setObject:color forKey:NSForegroundColorAttributeName];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    TextCell *cell = [super copyWithZone:zone];
    if (cell != nil) {
        cell->_text = [_text copyWithZone:zone];
    }
    return cell;
}

- (void)dealloc
{
    [_text release]; _text = nil;
    [super dealloc];
}

- (NSString *)text
{
    return _text;
}

- (void)setText:(NSString *)text
{
    if (text == nil) {
        return;
    }
    
    [_text release]; _text = nil;
    _text = [text copy];
    [self setStringValue:text];
}

- (void)setControlView:(NSView *)controlView
{
    [super setControlView:controlView];
}

- (void)setBackgroundStyle:(NSBackgroundStyle)style
{
    [super setBackgroundStyle:style];
}

- (NSRect)_textFrameForInteriorFrame:(NSRect)frame
{
    NSRect result = frame;
    NSSize naturalSize = [super cellSize];
    naturalSize.height = 16;//包含 \n, 文字显示会错乱  2015-07-17
    result.origin.y += (result.size.height - naturalSize.height)/2;
    result.size.height = naturalSize.height;
    return result;
}

//设置选中行高亮颜色时, 文字部分不是蓝色（ NSTableViewSelectionHighlightStyleRegular）
- (NSColor *)highlightColorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    return nil;
}

- (void)drawInteriorWithFrame:(NSRect)frame inView:(NSView *)controlView
{
    //Title
//    if (_textAttribute) {
//        NSMutableAttributedString *attributeTitle = [[NSMutableAttributedString alloc] initWithAttributedString:[self attributedStringValue]];
//        [attributeTitle addAttributes:_textAttribute
//                                range:NSMakeRange(0, self.stringValue.length)];
//        [self setAttributedStringValue:attributeTitle];
//        [attributeTitle release]; attributeTitle = nil;
//    }
    
    //选中行 Title 颜色
    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
    NSFont *font = [NSFont systemFontOfSize:13];
    NSColor *color = nil;
    if (self.isSelected) {
        color = [[NSColor blueColor] retain];
    }
    else {
        color = [[NSColor blackColor] retain];
    }
    
    [attributes setValue:font forKey:NSFontAttributeName];
    [attributes setValue:color forKey:NSForegroundColorAttributeName];
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithAttributedString:[self attributedStringValue]];
    [attrString addAttributes:attributes range:NSMakeRange(0, self.text.length)];
    [self setAttributedStringValue:attrString];
    
    [attributes release], attributes = nil;
    [attrString release], attrString = nil;
    
    NSRect textFrame = [self _textFrameForInteriorFrame:frame];
    [super drawInteriorWithFrame:textFrame inView:controlView];
}

- (NSUInteger)hitTestForEvent:(NSEvent *)event inRect:(NSRect)frame ofView:(NSView *)controlView
{
    NSPoint point = [controlView convertPoint:[event locationInWindow] fromView:nil];
    NSRect titleFrame = [self _textFrameForInteriorFrame:frame];
    if (NSPointInRect(point, titleFrame)) {
        return [super hitTestForEvent:event inRect:titleFrame ofView:controlView];
    }
    
    return NSCellHitNone;
}

@end
