//
//  ImageAndButtonItem.h
//  AppleDeviceManager
//
//  Created by 沧海无际 on 14-6-10.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageAndButtonItem : NSObject{
    NSImage *_image;
    NSString *_name;
    NSInteger _tag;
}
@property(retain) NSImage *image;
@property(retain) NSString *name;
@property(assign) NSInteger tag;
@end
