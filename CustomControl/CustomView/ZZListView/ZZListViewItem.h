//
//  ListViewItem.h
//  CustomControl
//
//  Created by liww on 2014/12/2.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZZListView;


typedef enum {
    State_None,
    State_Prepare,
    State_Start,
    State_Success,
    State_Fail,
    State_Abort,
}State;

/**
 ListViewItem: ListView中使用的数据对象
 */
@interface ZZListViewItem : NSObject{
    CGFloat             _itemHeight;
    NSString            *_text;
    NSString            *_description;
    NSString            *_percent;
    NSAttributedString  *_attributedText;
    NSImage             *_stateImage;
    State               _state;
    CGFloat             _alphaValue;
}
@property (atomic, assign) CGFloat itemHeight;
@property (atomic, copy) NSString *text;
@property (nonatomic, copy) NSString *description;
@property (nonatomic, copy) NSString *percent;
@property (atomic, copy) NSAttributedString *attributedText;
@property (atomic, retain) NSImage *stateImage;
@property (atomic, assign) State state;
@property (nonatomic)CGFloat alphaValue;

@end


/**
 ListViewItemMgr: 管理ListView中使用的数据对象
 */
@interface ZZListViewItemMgr : NSObject{
    NSMutableArray      *_items;
    ZZListView          *_listView;
}

- (id)initWithListView:(ZZListView *)listView;

- (NSArray *)items;
- (NSInteger)itemCount;

- (ZZListViewItem *)itemAtIndex:(NSInteger)index;
- (NSInteger)indexOfItem:(ZZListViewItem *)item;
- (CGFloat)heightAtIndex:(NSInteger)index;

- (void)setText:(NSString *)text
    description:(NSString *)description
          state:(State)state
        atIndex:(NSInteger)index
       isReload:(BOOL)isReload;

- (void)setText:(NSString *)text
    description:(NSString *)description
          state:(State)state
           item:(ZZListViewItem *)item
       isReload:(BOOL)isReload;

- (void)setState:(State)state atIndex:(NSInteger)index isReload:(BOOL)isReload;
- (void)setText:(NSString *)text atIndex:(NSInteger)index isReload:(BOOL)isReload;
- (void)resetItemState;

- (void)addItem:(ZZListViewItem *)item;
- (void)insertItem:(ZZListViewItem *)item atIndex:(NSInteger)index;

- (void)removeItem:(ZZListViewItem *)item;
@end
