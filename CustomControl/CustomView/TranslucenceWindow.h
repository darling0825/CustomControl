//
//  TranslucenceWindow.h
//  Dr.Fone_For_Android(Mac)
//
//  Created by 沧海无际 on 15-3-23.
//  Copyright (c) 2015年 darlingcoder. All rights reserved.
//

#import "CustomWindow.h"

typedef void * CGSConnection;
extern OSStatus CGSNewConnection(const void **attributes, CGSConnection * id);

@class CustomWindow;

@interface TranslucenceWindow : CustomWindow{
    NSColor         *_color;
}
@property (copy)NSColor *backgroundColor;
@end
