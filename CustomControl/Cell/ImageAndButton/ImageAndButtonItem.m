//
//  ImageAndButtonItem.m
//  AppleDeviceManager
//
//  Created by 沧海无际 on 14-6-10.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "ImageAndButtonItem.h"

@implementation ImageAndButtonItem
@synthesize image = _image;
@synthesize name = _name;
@synthesize tag = _tag;

- (void)dealloc
{
    [_image release]; _image = nil;
    [_name release]; _name = nil;
    [super dealloc];
}
@end
