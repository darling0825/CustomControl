//
//  DateAndTypeCell.h
//  CustomControl
//
//  Created by 沧海无际 on 7/30/14.
//  Copyright (c) 2014 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TextCell : NSTextFieldCell{
    NSString            *_text;
//    NSMutableDictionary *_textAttribute;
    
    NSInteger           selected_;
}
@property (readwrite,copy) NSString *text;
@property(getter=isSelected)NSInteger selected;
@end
