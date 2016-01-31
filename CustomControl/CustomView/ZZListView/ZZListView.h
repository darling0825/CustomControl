//
//  ZZListView.h
//  CustomControl
//
//  Created by liww on 2014/12/1.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ZZListViewCell.h"

@class ZZListView;
@class ZZListViewCell;

@protocol ZZListViewDelegate <NSObject>
@optional
- (void)listView:(ZZListView *)listView willDisplayCell:(ZZListViewCell *)cell forItemAtIndex:(NSInteger)index;
- (CGFloat)listView:(ZZListView *)listView heightOfRow:(NSInteger)index;
@end


@protocol ZZListViewDataSource <NSObject>
- (NSInteger)numberOfItemsInListView:(ZZListView *)listView;
- (ZZListViewCell *)listView:(ZZListView *)listView cellForItemAtIndex:(NSInteger)index;
@end


@interface ZZListView : NSView{
    NSMutableDictionary         *_classIdentifiers;
    NSMutableDictionary         *_keyedVisibleItems;
    NSMutableDictionary         *_reuseableItems;
    NSMutableDictionary         *_itemAttributes;
    NSMutableDictionary         *_keyedVisibleItemAttributes;
    
    NSMutableArray              *_itemIndexs;
    NSInteger                   _numberOfItems;
    
    BOOL                        _isInitialCall;
    
    id< ZZListViewDelegate>     _delegate;
    id< ZZListViewDataSource>   _dataSource;
}
@property(nonatomic, assign) id< ZZListViewDelegate> delegate;
@property(nonatomic, assign) id< ZZListViewDataSource> dataSource;

- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;
- (id)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier
                                    forIndex:(NSInteger)index;
- (void)reloadData;
- (void)reloadItemAtIndex:(NSInteger)index;

- (NSInteger)numberOfItems;
- (NSInteger)indexForCell:(ZZListViewCell *)cell;
- (ZZListViewCell *)cellForItemAtIndex:(NSInteger)index;
@end

@interface ZZListViewLayoutAttributes : NSObject{
    NSRect _frame;
    NSInteger _index;
}
@property(nonatomic) NSRect frame;
@property(nonatomic) NSInteger index;

+ (instancetype)layoutAttributesForCellWithIndex:(NSInteger)index;
@end
