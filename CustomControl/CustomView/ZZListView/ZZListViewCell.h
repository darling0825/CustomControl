//
//  ZZListViewCell.h
//  CustomControl
//
//  Created by liww on 2014/12/1.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ZZListViewCell : NSViewController{
    IBOutlet NSTextField *_textLabel;
    IBOutlet NSTextField *_descriptionLabel;
    IBOutlet NSTextField *_percentLabel;
    IBOutlet NSImageView *_imageView;
    NSString    *_text;
    NSString    *_description;
    NSString    *_percent;
    NSImage     *_image;
    NSString    *_reuseIdentifier;
    CGFloat     _alphaValue;
}
@property (nonatomic, readonly, copy) NSString *reuseIdentifier;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *percent;
@property (nonatomic, retain)NSImage *image;
@property (nonatomic)CGFloat alphaValue;

- (void)prepareForReuse;
- (void)setAttributedDescription:(NSAttributedString *)attributedString;
- (void)setAttributedText:(NSAttributedString *)attributedString;
- (void)setAttributedPercent:(NSAttributedString *)attributedString;
@end
