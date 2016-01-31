//
//  MyCollectionSupplementaryView.h
//  CustomControl
//
//  Created by 沧海无际 on 14/11/8.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LZCollectionReusableView.h"
#import "CustomView.h"

@interface MyCollectionSupplementaryView : LZCollectionReusableView{
    IBOutlet NSImageView *_imageView;
    IBOutlet NSTextField *_textField;
    IBOutlet CustomView  *_backgroundView;
}
@property(nonatomic,retain) IBOutlet NSImage *image;
@property(nonatomic,copy) IBOutlet NSString *text;

@end
