//
//  DataItem.h
//  CustomControl
//
//  Created by 沧海无际 on 14-6-15.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    MixedState = -1,
    OffState   = 0,
    OnState    = 1
};
typedef NSInteger SelectStateValue;

@interface DataItem : NSObject {
    SelectStateValue        _selected;
    NSImage                 *_image;
    NSString                *_title;
    NSString                *_content;
    NSMutableArray          *_children;
}
@property(assign, getter = isSelected) SelectStateValue selected;
@property(retain) NSImage *image;
@property(copy) NSString *title;
@property(copy) NSString *content;
@property(retain) NSMutableArray *children;

- (id)initWithTitle:(NSString *)title;
+ (DataItem *)dataItemWithTitle:(NSString *)title;
@end
