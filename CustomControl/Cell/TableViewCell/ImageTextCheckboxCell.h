//
//  ImageTextCheckboxCell.h
//  CustomControl
//
//  Created by 沧海无际 on 14-5-3.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define CheckboxStateDidChanged         @"CheckboxStateDidChanged"
#define DoubleClickImageDidFinish       @"DoubleClickImageDidFinish"

@interface ImageTextCheckboxCell : NSTextFieldCell{
    NSImageCell     *_imageCell;
    NSButtonCell    *_checkBoxCell;
}
@property(retain) NSImage *image;
@property(retain) NSString *name;
@property(assign,getter = isSelected) BOOL selected;

@end
