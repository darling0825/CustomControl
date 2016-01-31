//
//  LZListViewCell.h
//  CustomControl
//
//  Created by liww on 2014/12/1.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface LZListViewCell : NSView{
    IBOutlet NSTextField *_textField;
    IBOutlet NSImageView *_imageView;
    NSString    *_text;
    NSImage     *_image;
    NSString    *_reuseIdentifier;
}
@property (nonatomic, readonly, copy) NSString *reuseIdentifier;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, retain)NSImage *image;

- (void)prepareForReuse;

@end
