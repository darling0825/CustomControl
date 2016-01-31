//
//  DataItem.m
//  CustomControl
//
//  Created by 沧海无际 on 14-6-15.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "DataItem.h"

@implementation DataItem
@synthesize selected = _selected;
@synthesize image = _image;
@synthesize title = _title;
@synthesize content = _content;
@synthesize children = _children;

- (id)init
{
    return [self initWithTitle:@"Untitled"];
}

- (id)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.selected = NO;
        self.image = [[[NSImage alloc] init] autorelease];
        self.title = title;
        self.content = [[[NSString alloc] init] autorelease];
        self.children = [[[NSMutableArray alloc] init] autorelease];
    }
    return self;
}

+ (DataItem *)dataItemWithTitle:(NSString *)title
{
    return [[[DataItem alloc] initWithTitle:title] autorelease];
}

- (void)dealloc
{
    [_image release]; _image = nil;
    [_title release]; _title = nil;
    [_content release]; _content = nil;
    [_children release]; _children = nil;
    [super dealloc];
}
@end
