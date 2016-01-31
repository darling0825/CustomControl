//
//  ImageTextCell.h
//  CustomControl
//
//  Created by 沧海无际 on 14-5-3.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ImageCell : NSTextFieldCell{
    NSImageCell     *_imageCell;
}
@property(retain) NSImage *image;

@end
