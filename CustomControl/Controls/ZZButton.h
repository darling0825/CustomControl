//
//  ZZButton.h
//  CustomControl
//
//  Created by System Administrator on 13-8-15.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ZZButton : NSButton
/**
 按钮图片是否进行伸缩处理
 */
@property(nonatomic, getter = isStretchable)BOOL stretchable;
@property(nonatomic, getter = isAllowUnderline)BOOL allowUnderline;
- (void)setButtonImage:(NSImage *)image;

- (void)setButtonStateImageWithNormal:(NSImage *)normal
                                   up:(NSImage *)up
                                 down:(NSImage *)down
                              disable:(NSImage *)disable;
- (void)setTitleColorWithNormal:(NSColor *)normal
                             up:(NSColor *)up
                           down:(NSColor *)down
                        disable:(NSColor *)disable;

- (void)setButtonTitle:(NSAttributedString *)title;

- (void)setButtonTitle:(NSString *)title
              fontName:(NSString *)name 
              fontSize:(NSInteger)size 
             fontColor:(NSColor *)color
                 align:(NSTextAlignment)align
             underline:(BOOL)underline
        attributeRange:(NSRange)range;

- (void)setTitle:(NSString *)title font:(NSFont *)font;
- (void)setAlign:(NSTextAlignment)align;
- (void)setAllowUnderline:(BOOL)underline;

@end


@interface ZZButtonCell : NSButtonCell{
    NSImage             *_image;
    NSColor             *_color;
    NSAttributedString  *_title;
    
    NSImage             *_normalImg;
    NSImage             *_downImage;
    NSImage             *_upImage;
    NSImage             *_disableImage;
    
    NSColor             *_normalColor;
    NSColor             *_downColor;
    NSColor             *_upColor;
    NSColor             *_disableColor;
    
    BOOL                _mouseEnterOrExit;
    BOOL                _mouseUpOrDown;
    BOOL                _isSetFourImage;
    BOOL                _isSetFourColor;
    
    BOOL                _stretchable;
    BOOL                _allowUnderline;
}
/**
 按钮图片是否进行伸缩处理
 */
@property(nonatomic, getter = isStretchable)BOOL stretchable;
@property(nonatomic, getter = isAllowUnderline)BOOL allowUnderline;

- (void)setButtonImage:(NSImage *)image;

- (void)setButtonStateImageWithNormal:(NSImage *)normal
                                   up:(NSImage *)up
                                 down:(NSImage *)down
                              disable:(NSImage *)disable;
- (void)setTitleColorWithNormal:(NSColor *)normal
                             up:(NSColor *)up
                           down:(NSColor *)down
                        disable:(NSColor *)disable;

- (void)setButtonTitle:(NSAttributedString *)title;

- (void)setButtonTitle:(NSString *)title
              fontName:(NSString *)name
              fontSize:(NSInteger)size
             fontColor:(NSColor *)color
                 align:(NSTextAlignment)align
             underline:(BOOL)underline
        attributeRange:(NSRange)range;

- (void)setTitle:(NSString *)title font:(NSFont *)font;
- (void)setAlign:(NSTextAlignment)align;
- (void)setAllowUnderline:(BOOL)underline;
@end
