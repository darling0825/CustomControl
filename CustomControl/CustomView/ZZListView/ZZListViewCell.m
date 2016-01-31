//
//  ZZListViewCell.m
//  CustomControl
//
//  Created by liww on 2014/12/1.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "ZZListViewCell.h"

@implementation ZZListViewCell
@dynamic reuseIdentifier;
@dynamic text;
@dynamic description;
@dynamic percent;
@dynamic image;
@synthesize alphaValue = _alphaValue;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // 初始化时加载xib文件
        BOOL loadSuccess = NO;
        if ([[NSBundle bundleForClass:[self class]] respondsToSelector:@selector(loadNibNamed:owner:topLevelObjects:)]) {
            // We're running on Mountain Lion or higher
            loadSuccess = [[NSBundle bundleForClass:[self class]] loadNibNamed:@"ZZListViewCell"
                                                        owner:self
                                              topLevelObjects:nil];
            
        }
        else {
            // We're running on Lion
            loadSuccess = [NSBundle loadNibNamed:@"ZZListViewCell"
                                           owner:self];
        }
        
        if (!loadSuccess) {
            return nil;
        }
        
        _alphaValue = 1.0;
    }
    
    return self;
}

- (void)dealloc
{
    [_text release]; _text = nil;
    [_description release]; _description = nil;
    [_percent release]; _percent = nil;
    [super dealloc];
}

- (void)prepareForReuse
{
    
}

- (NSString *)reuseIdentifier
{
    return _reuseIdentifier;
}

- (void)setReuseIdentifier:(NSString *)reuseIdentifier
{
    [_reuseIdentifier release]; _reuseIdentifier = nil;
    _reuseIdentifier = [reuseIdentifier copy];
}

- (NSString *)text
{
    return _text;
}

- (void)setText:(NSString *)text
{
    if (text) {
        [_textLabel setAlphaValue:_alphaValue];
        [_textLabel setStringValue:text];
        
        [_text release]; _text = nil;
        _text = [text copy];
    }
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<%@>:%@,%@", [self className], _text, _description];
}

- (void)setDescription:(NSString *)description
{
    if (description) {
        [_descriptionLabel setAlphaValue:_alphaValue];
        [_descriptionLabel setStringValue:description];
        
        [_description release]; _description = nil;
        _description = [description copy];
    }
}

- (NSString *)percent
{
    return _percent;
}

- (void)setPercent:(NSString *)percent
{
    if (percent) {
        [_percentLabel setAlphaValue:_alphaValue];
        [_percentLabel setStringValue:percent];
        
        [_percent release]; _percent = nil;
        _percent = [percent copy];
    }
}

- (void)setAttributedDescription:(NSAttributedString *)attributedString
{
    if (attributedString) {
        [_descriptionLabel setAttributedStringValue:attributedString];
    }
}

- (void)setAttributedText:(NSAttributedString *)attributedString
{
    if (attributedString) {
        [_textLabel setAttributedStringValue:attributedString];
    }
}

- (void)setAttributedPercent:(NSAttributedString *)attributedString
{
    if (attributedString) {
        [_percentLabel setAttributedStringValue:attributedString];
    }
}

- (NSImage *)image
{
    return _image;
}

- (void)setImage:(NSImage *)image
{
    [_imageView setImage:image];
    
    [image retain];
    [_image release]; _image = nil;
    _image = image;
}

@end
