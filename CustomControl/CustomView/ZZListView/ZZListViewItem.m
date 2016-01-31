//
//  ListViewItem.m
//  CustomControl
//
//  Created by liww on 2014/12/2.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "ZZListViewItem.h"
#import "ZZListView.h"

#define DefaultListViewItemRowHeight 80.0

static NSImage *prepareStateImage = nil;
static NSImage *startStateImage = nil;
static NSImage *successStateImage = nil;
static NSImage *failStateImage = nil;
static NSImage *abortStateImage = nil;

@implementation ZZListViewItem
@synthesize itemHeight = _itemHeight;
@synthesize text = _text;
@synthesize description = _description;
@synthesize percent = _percent;
@synthesize attributedText = _attributedText;
@synthesize stateImage = _stateImage;
@synthesize state = _state;
@synthesize alphaValue = _alphaValue;

- (id)init
{
    self = [super init];
    if (self) {
        _itemHeight = DefaultListViewItemRowHeight;
        _text = nil;
        _attributedText = nil;
        _stateImage = nil;
        _state = State_None;
        _alphaValue = 1.0;
    }
    return self;
}

- (void)dealloc
{
    [_text release]; _text = nil;
    [_description release]; _description = nil;
    [_percent release]; _percent = nil;
    [_stateImage release]; _stateImage = nil;
    [super dealloc];
}

@end


@interface ZZListViewItemMgr ()
@end

@implementation ZZListViewItemMgr
+ (void)initialize
{
    prepareStateImage = [[NSImage imageNamed:@"AnimationRootProgress"] retain];
    startStateImage = [[NSImage imageNamed:@"AnimationRootProgress"] retain];
    successStateImage = [[NSImage imageNamed:@"icon_big_1"] retain];
    failStateImage = [[NSImage imageNamed:@"icon_big_3"] retain];
    abortStateImage = [[NSImage imageNamed:@"icon_big_1"] retain];
}

- (id)init
{
    return [self initWithListView:nil];
}

- (void)dealloc
{
    [_items release]; _items = nil;
    [_listView release]; _listView = nil;
    [super dealloc];
}

- (id)initWithListView:(ZZListView *)listView
{
    self = [super init];
    if (self) {
        _items = [[NSMutableArray alloc] init];
        _listView = [listView retain];
    }
    return self;
}

- (NSArray *)items
{
    return _items;
}

- (NSInteger)itemCount
{
    return [_items count];
}

- (ZZListViewItem *)itemAtIndex:(NSInteger)index
{
    if (index < 0 || index >= [_items count]) {
        return nil;
    }
    return [_items objectAtIndex:index];
}

- (NSInteger)indexOfItem:(ZZListViewItem *)item
{
    if (item == nil) {
        return -1;
    }
    
    return [_items indexOfObject:item];
}

- (CGFloat)heightAtIndex:(NSInteger)index
{
    ZZListViewItem *item = [_items objectAtIndex:index];
    if (item == nil) {
        return 0.0;
    }
    return [item itemHeight];
}

- (void)setText:(NSString *)text
    description:(NSString *)description
          state:(State)state
        atIndex:(NSInteger)index
       isReload:(BOOL)isReload
{
    ZZListViewItem *item = [_items objectAtIndex:index];
    if (item) {
        @synchronized(_items){
            [item setText:text];
            [item setDescription:description];
            [item setStateImage:[self _imageForState:state]];
            [item setState:state];
        }
    }
    if (isReload) {
        [_listView reloadItemAtIndex:[self indexOfItem:item]];
    }
}

- (void)setText:(NSString *)text
    description:(NSString *)description
          state:(State)state
           item:(ZZListViewItem *)item
       isReload:(BOOL)isReload
{
    if (item) {
        @synchronized(_items){
            [item setText:text];
            [item setDescription:description];
            [item setStateImage:[self _imageForState:state]];
            [item setState:state];
        }
        if (isReload) {
            [_listView reloadItemAtIndex:[self indexOfItem:item]];
        }
    }
}

- (void)setState:(State)state atIndex:(NSInteger)index isReload:(BOOL)isReload
{
    ZZListViewItem *item = [_items objectAtIndex:index];
    if (item) {
        @synchronized(_items){
            [item setStateImage:[self _imageForState:state]];
            [item setState:state];
        }
        if (isReload) {
            [_listView reloadItemAtIndex:[self indexOfItem:item]];
        }
    }
}

- (void)setText:(NSString *)text atIndex:(NSInteger)index isReload:(BOOL)isReload
{
    ZZListViewItem *item = [_items objectAtIndex:index];
    if (item) {
        @synchronized(_items){
            [item setText:text];
        }
        if (isReload) {
            [_listView reloadItemAtIndex:[self indexOfItem:item]];
        }
    }
}

- (void)resetItemState
{
    [_items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ZZListViewItem *item = (ZZListViewItem *)obj;
        dispatch_async(dispatch_get_main_queue(), ^{

            [item setStateImage:[self _imageForState:State_Prepare]];
            [_listView reloadItemAtIndex:[self indexOfItem:item]];
        });
    }];
}

- (void)insertItem:(ZZListViewItem *)item atIndex:(NSInteger)index
{
    [_items insertObject:item atIndex:index];
    [_listView reloadData];
}

- (void)addItem:(ZZListViewItem *)item
{
    [_items addObject:item];
    [_listView reloadData];
}

- (void)removeItem:(ZZListViewItem *)item
{
    [_items removeObject:item];
    [_listView reloadData];
}

- (NSImage *)_imageForState:(State)state
{
    NSImage *image = nil;
    switch (state) {
        case State_Prepare:
            image = prepareStateImage;
            break;
        case State_Start:
            image = startStateImage;
            break;
        case State_Success:
            image = successStateImage;
            break;
        case State_Fail:
            image = failStateImage;
            break;
        case State_Abort:
            image = abortStateImage;
            break;
            
        default:
            break;
    }
    return image;
}

@end