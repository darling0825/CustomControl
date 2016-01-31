//
//  LZListView.h
//  CustomControl
//
//  Created by liww on 2014/12/1.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "LZListViewCell.h"

@class LZListView;
@class LZListViewCell;

@protocol LZListViewDelegate <NSObject>
@optional
- (void)listView:(LZListView *)listView willDisplayCell:(LZListViewCell *)cell forItemAtIndex:(NSInteger)index;
- (CGFloat)listView:(LZListView *)listView heightOfRow:(NSInteger)index;
@end


@protocol LZListViewDataSource <NSObject>
- (NSInteger)numberOfItemsInListView:(LZListView *)listView;
- (LZListViewCell *)listView:(LZListView *)listView cellForItemAtIndex:(NSInteger)index;
@end


@interface LZListView : NSView{
    NSMutableDictionary         *_classIdentifiers;
    NSMutableDictionary         *_keyedVisibleItems;
    NSMutableDictionary         *_reuseableItems;
    NSMutableDictionary         *_itemAttributes;
    NSMutableDictionary         *_keyedVisibleItemAttributes;
    
    NSMutableArray              *_itemIndexs;
    NSInteger                   _numberOfItems;
    
    BOOL                        _isInitialCall;
    
    id< LZListViewDelegate>     _delegate;
    id< LZListViewDataSource>   _dataSource;
}
@property(nonatomic, assign) id< LZListViewDelegate> delegate;
@property(nonatomic, assign) id< LZListViewDataSource> dataSource;

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier
                                    forIndex:(NSInteger)index;
- (void)reloadData;
- (void)reloadItemAtIndex:(NSInteger)index;
- (void)setNeedsDisplay;

- (NSInteger)numberOfItems;
- (NSInteger)indexForCell:(LZListViewCell *)cell;
- (LZListViewCell *)cellForItemAtIndex:(NSInteger)index;
@end

@interface LZListViewLayoutAttributes : NSObject{
    NSRect _frame;
    NSInteger _index;
}
@property(nonatomic) NSRect frame;
@property(nonatomic) NSInteger index;

+ (instancetype)layoutAttributesForCellWithIndex:(NSInteger)index;
@end
