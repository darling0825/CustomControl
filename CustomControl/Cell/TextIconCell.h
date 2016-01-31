//
//  ImageTextCell.h
//  CustomControl
//
//  Created by 沧海无际 on 14-5-3.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TextIconCell : NSTextFieldCell{
    NSImageCell         *_imageCell;
    NSMutableDictionary *_textAttribute;
}
@property (readwrite,copy) NSString *text;
@property(retain) NSImage *image;

@end
