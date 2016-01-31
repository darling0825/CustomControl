//
//  LZGridViewDelegate.h
//  CustomControl
//
//  Created by 沧海无际 on 14-9-27.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Foundation/Foundation.h>


@class LZGridView;
@class LZGridViewItem;

#pragma mark LZGridViewDelegate

@protocol LZGridViewDelegate <NSObject>
@optional
/**
 ...
 */
- (void)gridView:(LZGridView *)gridView didClickItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section;

/**
 ...
 */
- (void)gridView:(LZGridView *)gridView didDoubleClickItemAtIndex:(NSUInteger)index inSection:(NSUInteger)section;

/**
 ...
 */
- (NSSize)insetMarginInGridView:(LZGridView *)gridView;

@end




#pragma mark - LZGridViewDataSource

@protocol LZGridViewDataSource <NSObject>

/**
 ...
 */
- (NSViewController *)reusableItemForGridView:(LZGridView *)gridView inSection:(NSInteger)section;

/**
 ...
 */
- (NSUInteger)gridView:(LZGridView *)gridView numberOfItemsInSection:(NSInteger)section;

/**
 ...
 */
- (void)gridView:(LZGridView *)gridView willShowViewController:(NSViewController *)viewController itemAtIndex:(NSInteger)index;

@optional
- (NSUInteger)numberOfSectionsInGridView:(LZGridView *)gridView;
- (NSViewController *)reusableHeaderForGridView:(LZGridView *)gridView inSection:(NSInteger)section;
- (void)gridView:(LZGridView *)gridView willShowHeaderViewController:(NSViewController *)viewController inSection:(NSInteger)section;

@end
