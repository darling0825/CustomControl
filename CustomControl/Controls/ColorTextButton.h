//
//  ColorTextButton.h
//  CustomControl
//
//  Created by 沧海无际 on 15-3-18.
//  Copyright (c) 2015年 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSButton (ColorButton)
- (void)setHoverColor:(NSColor *)textColor;
- (void)setNormalColor:(NSColor *)textColor;
- (void)setPushColor:(NSColor *)textColor;
- (void)setDisableColor:(NSColor *)textColor;
- (void)setHeightLight:(BOOL)b;
@end

@interface CustomButton : NSButton
@end

@interface ColorButtonCell : NSButtonCell
{
    BOOL bClick;
}
@property (nonatomic,retain) NSColor *normal;
@property (nonatomic,retain) NSColor *hover;
@property (nonatomic,retain) NSColor *push;
@property (nonatomic,retain) NSColor *disable;
@end

/*使用方法
 [aButton setHoverColor:[NSColor colorWithDeviceRed:0.5059 green:0.7451 blue:0.1961 alpha:1]];
 [aButton setPushColor:[NSColor colorWithDeviceRed:0.5059 green:0.7451 blue:0.1961 alpha:1]];
 [aButton setNormalColor:[NSColor colorWithDeviceRed:0.2471 green:0.2471 blue:0.2471 alpha:1]];
*/