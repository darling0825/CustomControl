//
//  LZUrlLabel.h
//  CustomControl
//
//  Created by 沧海无际 on 14-5-10.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LZUrlLabel : NSTextField{
    BOOL                _isUnderLine;
    NSURL               *_url;
    NSColor             *_color;
    NSRange             _underLineRange;
    NSTextAlignment     _align;
//    id          _target;
//    SEL         _action;
}
/*
 先setStringValue, 后setUrl, 否则没有下划线
 */
@property (nonatomic, retain)NSURL *url;
@property (nonatomic, retain)NSColor *color;
@property (nonatomic, assign)NSRange underLineRange;
@property (nonatomic, getter=isUnderLine)BOOL underLine;
@property (nonatomic, assign)NSTextAlignment align;

//使用指定的Action打开
//- (void)setTarget:(id)anObject;
//- (void)setAction:(SEL)aSelector;

@end
