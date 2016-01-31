//
//  ListViewItem.h
//  CustomControl
//
//  Created by liww on 2014/12/2.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import <Foundation/Foundation.h>


@class LZListView;

/**
 enum ListViewItemType
 enum EraserState
 */
typedef enum {
    ListViewItemType_None,
    ListViewItemType_DeleteMedia,
    ListViewItemType_DeletePhoto,
    ListViewItemType_DeleteApp,
    ListViewItemType_DeletePrivate,
    ListViewItemType_DeleteSystemSetting,
    ListViewItemType_RestartDevice,
    ListViewItemType_FillData,
    ListViewItemType_Delete,
    ListViewItemType_FirstRestart,
    ListViewItemType_SavePhoto,
    ListViewItemType_SecondRestart,
    ListViewItemType_RestartTimeout,
    ListViewItemType_DeleteFail,
}ListViewItemType;

typedef enum {
    EraserState_None,
    EraserState_Prepare,
    EraserState_Start,
    EraserState_Success,
    EraserState_Fail,
    EraserState_Abort,
}EraserState;

/**
 ListViewItem: ListView中使用的数据对象
 */
@interface ListViewItem : NSObject{
    ListViewItemType    _itemType;
    CGFloat             _itemHeight;
    NSString            *_text;
    NSImage             *_stateImage;
    EraserState         _state;
}
@property (atomic, assign) ListViewItemType itemType;
@property (atomic, assign) CGFloat itemHeight;
@property (atomic, copy) NSString *text;
@property (atomic, retain) NSImage *stateImage;
@property (atomic, assign) EraserState state;

@end


/**
 ListViewItemMgr: 管理ListView中使用的数据对象
 */
@interface ListViewItemMgr : NSObject{
    NSMutableArray      *_items;
    NSMutableDictionary *_itemsDic;
    LZListView          *_listView;
}

- (id)initWithItemType:(NSArray *)itemTypes listView:(LZListView *)listView;

- (NSArray *)items;
- (NSInteger)itemCount;

- (ListViewItem *)itemAtIndex:(NSInteger)index;
- (NSInteger)indexOfItem:(ListViewItem *)item;
- (CGFloat)heightForType:(ListViewItemType)type;

- (void)setText:(NSString *)text
          state:(EraserState)state
        forType:(ListViewItemType)type
       isReload:(BOOL)isReload;

- (void)setState:(EraserState)state forType:(ListViewItemType)type isReload:(BOOL)isReload;
- (void)setText:(NSString *)text forType:(ListViewItemType)type isReload:(BOOL)isReload;
- (void)resetItemState;

- (void)insertItem:(ListViewItem *)item atIndex:(NSInteger)index;
@end
