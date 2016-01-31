//
//  OutlineViewTestCtrl.m
//  CustomControl
//
//  Created by liww on 14-6-13.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "OutlineViewTestCtrl.h"
#import "DataItem.h"
#import "CheckboxImageTextCell.h"

@interface OutlineViewTestCtrl ()

@end

@implementation OutlineViewTestCtrl

- (id)init
{
    self = [super initWithWindowNibName:@"OutlineViewTestCtrl" owner:self];
    if (self) {
        _dataItems = [[NSMutableArray alloc] init];
        _cell = [[CheckboxImageTextCell alloc] init];
        //_rootTreeNode = [[NSTreeNode alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(checkboxStateDidChanged:)
                                                     name:@"CheckboxStateDidChanged"
                                                   object:nil];
        
        [self createDataItemV2];
        [self createOutlineView];
    }
    return self;
}

- (void)dealloc
{
    [_dataItems     release]; _dataItems    = nil;
    [_cell          release]; _cell         = nil;
    [_rootTreeNode  release]; _rootTreeNode = nil;
    [_iconImages    release]; _iconImages   = nil;
    [super dealloc];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    //[_outlineView reloadData];
}

- (void)awakeFromNib
{
    
}

- (void)createOutlineView
{
    NSScrollView *containerView = [[NSScrollView alloc] initWithFrame:NSMakeRect(10, 10, 610, 390)];
    //滚动条
    containerView.hasHorizontalScroller = YES;
    containerView.hasVerticalScroller = YES;
    containerView.autohidesScrollers = YES;
    
    _outlineView = [[LZOutlineView alloc] init];
    [_outlineView setDataSource:self];
    [_outlineView setDelegate:self];
    
    //默认展开根节点及其子节点
    //[_outlineView expandItem:nil expandChildren:YES];
    
    //Triangle
    NSTableColumn *triangleColumn = [[NSTableColumn alloc] init];
    [_outlineView setOutlineTableColumn:triangleColumn];
    [triangleColumn release]; triangleColumn = nil;
    
    //Column 1
    NSTableColumn *column1 = [[NSTableColumn alloc] initWithIdentifier:@"title"];
    [column1.headerCell setTitle:@"Data Item"];
    [column1 setWidth:250];
    [_outlineView addTableColumn:column1];
    [column1 release]; column1 = nil;
    
    //Column 2
    NSTableColumn *column2 = [[NSTableColumn alloc] initWithIdentifier:@"content"];
    [column2.headerCell setTitle:@"Data Content"];
    [column2 setWidth:200];
    [_outlineView addTableColumn:column2];
    [column2 release]; column2 = nil;
    
    [containerView setDocumentView:_outlineView];
    [self.window.contentView addSubview:containerView];
    [containerView release]; containerView = nil;
}

- (void)createDataItem
{
    DataItem *rootItem = [[DataItem alloc] init];
    rootItem.title = @"Root";
    rootItem.content = @"Root1234567890";
    rootItem.selected = NO;
    rootItem.image = [NSImage imageNamed:@"iPhone"];
    [_dataItems addObject:rootItem];
    _rootTreeNode = [[NSTreeNode treeNodeWithRepresentedObject:rootItem] retain];
    [rootItem release]; rootItem = nil;
    
    DataItem *contactItem = [[DataItem alloc] init];
    contactItem.title = @"Contacts";
    contactItem.content = @"Contact1234567890";
    contactItem.selected = NO;
    contactItem.image = [NSImage imageNamed:@"Contacts"];
    [_dataItems addObject:contactItem];
    [[_rootTreeNode mutableChildNodes] addObject:[NSTreeNode treeNodeWithRepresentedObject:contactItem]];
    [contactItem release]; contactItem = nil;
    
    DataItem *messageItem = [[DataItem alloc] init];
    messageItem.title = @"Messages";
    messageItem.content = @"Message1234567890";
    messageItem.selected = NO;
    messageItem.image = [NSImage imageNamed:@"Messages"];
    [_dataItems addObject:messageItem];
    [[_rootTreeNode mutableChildNodes] addObject:[NSTreeNode treeNodeWithRepresentedObject:messageItem]];
    [messageItem release]; messageItem = nil;
    
    DataItem *calendarItem = [[DataItem alloc] init];
    calendarItem.title = @"Calendar";
    calendarItem.content = @"Callendar1234567890";
    calendarItem.selected = NO;
    calendarItem.image = [NSImage imageNamed:@"Calendar"];
    [_dataItems addObject:calendarItem];
    [[_rootTreeNode mutableChildNodes] addObject:[NSTreeNode treeNodeWithRepresentedObject:calendarItem]];
    [calendarItem release]; calendarItem = nil;
    
    DataItem *remainderItem = [[DataItem alloc] init];
    remainderItem.title = @"Reminders";
    remainderItem.content = @"Remainder1234567890";
    remainderItem.selected = NO;
    remainderItem.image = [NSImage imageNamed:@"Reminders"];
    [_dataItems addObject:remainderItem];
    [[_rootTreeNode mutableChildNodes] addObject:[NSTreeNode treeNodeWithRepresentedObject:remainderItem]];
    [remainderItem release]; contactItem = nil;
    
    DataItem *safariBookmarkItem = [[DataItem alloc] init];
    safariBookmarkItem.title = @"SafariBookmark";
    safariBookmarkItem.content = @"SafariBookmark1234567890";
    safariBookmarkItem.selected = NO;
    safariBookmarkItem.image = [NSImage imageNamed:@"SafariBookmark"];
    [_dataItems addObject:safariBookmarkItem];
    [[_rootTreeNode mutableChildNodes] addObject:[NSTreeNode treeNodeWithRepresentedObject:safariBookmarkItem]];
    [safariBookmarkItem release]; safariBookmarkItem = nil;
    
    DataItem *photoItem = [[DataItem alloc] init];
    photoItem.title = @"Photo";
    photoItem.content = @"Photo1234567890";
    photoItem.selected = NO;
    photoItem.image = [NSImage imageNamed:@"CameraRoll"];
    NSTreeNode *photoNode = [NSTreeNode treeNodeWithRepresentedObject:photoItem];
    
    DataItem *photoStreamItem = [[DataItem alloc] init];
    photoStreamItem.title = @"Photo Stream";
    photoStreamItem.content = @"PhotoStream1234567890";
    photoStreamItem.selected = NO;
    photoStreamItem.image = [NSImage imageNamed:@"PhotoStream"];
    NSTreeNode *photoStreamNode = [NSTreeNode treeNodeWithRepresentedObject:photoStreamItem];
    
    DataItem *photoLibraryItem = [[DataItem alloc] init];
    photoLibraryItem.title = @"Photo Library";
    photoLibraryItem.content = @"PhotoLibrary1234567890";
    photoLibraryItem.selected = NO;
    photoLibraryItem.image = [NSImage imageNamed:@"PhotoLibrary"];
    NSTreeNode *photoLibraryNode = [NSTreeNode treeNodeWithRepresentedObject:photoLibraryItem];
    
    [photoItem.children addObject:photoStreamItem];
    [photoItem.children addObject:photoLibraryItem];
    [_dataItems addObject:photoItem];
    
    [[photoNode mutableChildNodes] addObject:photoStreamNode];
    [[photoNode mutableChildNodes] addObject:photoLibraryNode];
    [[_rootTreeNode mutableChildNodes] addObject:photoNode];
    
    [photoStreamItem release]; photoStreamItem = nil;
    [photoLibraryItem release]; photoLibraryItem = nil;
    [photoItem release]; photoItem = nil;
}

- (void)createDataItemV2
{
    NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"InitInfo" ofType: @"dict"]];
    _rootTreeNode = [[self treeNodeFromDictionary:dictionary] retain];
}

- (NSArray *)childrenForItem:(id)item {
    if (item == nil) {
        return [_rootTreeNode childNodes];
    } else {
        return [item childNodes];
    }
//    if (item == nil) {
//        return _dataItems;
//    }
//    else{
//        DataItem *dataItem = (DataItem *)item;
//        return dataItem.children;
//    }
    
    return nil;
}

- (NSTreeNode *)treeNodeFromDictionary:(NSDictionary *)dictionary
{
    // We will use the built-in NSTreeNode with a representedObject that is our model object - the SimpleNodeData object.
    // First, create our model object.
    NSString *nodeName = [dictionary objectForKey:NAME_KEY];
    DataItem *nodeData = [DataItem dataItemWithTitle:nodeName];
    
    // The image for the nodeData is lazily filled in, for performance.
    nodeData.image = [self randomIconImage];
    nodeData.content = nodeName;
    
    // Create a NSTreeNode to wrap our model object. It will hold a cache of things such as the children.
    NSTreeNode *result = [NSTreeNode treeNodeWithRepresentedObject:nodeData];
    
    // Walk the dictionary and create NSTreeNodes for each child.
    NSArray *children = [dictionary objectForKey:CHILDREN_KEY];
    
    for (id item in children) {
        // A particular item can be another dictionary (ie: a container for more children), or a simple string
        NSTreeNode *childTreeNode;
        if ([item isKindOfClass:[NSDictionary class]]) {
            
            // Recursively create the child tree node and add it as a child of this tree node
            childTreeNode = [self treeNodeFromDictionary:item];
        }
        else {
            
            // It is a regular leaf item with just the name
            DataItem *childNodeData = [[DataItem alloc] initWithTitle:item];
            childNodeData.image = [self randomIconImage];
            childNodeData.content = item;
            childTreeNode = [NSTreeNode treeNodeWithRepresentedObject:childNodeData];
            [childNodeData release];
        }
        
        // Now add the child to this parent tree node
        [[result mutableChildNodes] addObject:childTreeNode];
    }
    return result;
}

- (NSImage *)randomIconImage {
    // The first time through, we create a random array of images to use for the items.
    if (_iconImages == nil) {
        _iconImages = [[NSMutableArray alloc] init]; // This is properly released in -dealloc
        // There is a set of images with the format "Image<number>.tiff" in the Resources directory. We go through and add them to the array until we are out of images.
        NSInteger i = 1;
        while (1) {
            // The typcast to a long and the use of %ld allows this application to easily be compiled as 32-bit or 64-bit
            NSString *imageName = [NSString stringWithFormat:@"Image%ld.tiff", (long)i];
            NSImage *image = [NSImage imageNamed:imageName];
            if (image != nil) {
                // Add the image to our array and loop to the next one
                [_iconImages addObject:image];
                i++;
            } else {
                // If the result is nil, then there are no more images
                break;
            }
        }
    }
    
    // We systematically iterate through the image array and return a result. Keep track of where we are in the array with a static variable.
    static NSInteger imageNum = 0;
    NSImage *result = [_iconImages objectAtIndex:imageNum];
    imageNum++;
    // Once we are at the end of the array, start over
    if (imageNum == [_iconImages count]) {
        imageNum = 0;
    }
    return result;
}

#pragma mark ============= Checkbox State Changed ============

- (DataItem *)_dataItemForRow:(NSInteger)row
{
    NSTreeNode *editingTreeNode = [_outlineView itemAtRow:row];
    return (DataItem *)[editingTreeNode representedObject];
}

- (void)checkboxStateDidChanged:(NSNotification *)note
{
    NSInteger editingRow = [_outlineView clickedRow];
    DataItem *dataItem = [self _dataItemForRow:editingRow];
    NSTreeNode *editingTreeNode = [_outlineView itemAtRow:editingRow];
    SelectStateValue state = [dataItem isSelected] < 1 ? OnState : OffState;
    [self setNode:editingTreeNode selectState:state];
    
    [_outlineView reloadData];
}

- (void)setNode:(NSTreeNode *)treeNode selectState:(SelectStateValue)state
{
    [self setChildNode:treeNode selectState:state];
    
    BOOL isAllSelected = YES;
    SelectStateValue pTreeNodeState = MixedState;
    for (NSTreeNode *childNode in [[treeNode parentNode] childNodes]) {
        DataItem *dataItem = [childNode representedObject];
        
        if (state) {
            if (dataItem.selected != OnState) {
                isAllSelected = NO;
                break;
            }
        }
        else{
            if (dataItem.selected == OnState) {
                isAllSelected = NO;
                break;
            }
        }
    }
    
    if (isAllSelected) {
        pTreeNodeState = OnState;
    }
    else if (state){
        pTreeNodeState = MixedState;
    }
    else{
        pTreeNodeState = OffState;
    }
    
    [self setParentNode:treeNode selectState:pTreeNodeState];

}

- (void)setChildNode:(NSTreeNode *)treeNode selectState:(SelectStateValue)state
{
    DataItem *dataItem = [treeNode representedObject];
    [dataItem setSelected:state];
    
    //child node
    if ([[treeNode childNodes] count] > 0) {
        for (NSTreeNode *childNode in [treeNode childNodes]) {
            [self setChildNode:childNode selectState:state];
        }
    }
}

- (void)setParentNode:(NSTreeNode *)treeNode selectState:(SelectStateValue)state
{
    NSTreeNode *pTreeNode = [treeNode parentNode];
    DataItem *dataItem = [pTreeNode representedObject];
    [dataItem setSelected:state];
    
    //parent node
    if ([pTreeNode parentNode] != nil) {
        [self setParentNode:pTreeNode selectState:state];
    }
}

#pragma mark =============  OutlineView DataSource =============
- (id)outlineView:(NSOutlineView *)outlineView child:(NSInteger)index ofItem:(id)item
{
    NSArray *children = [self childrenForItem:item];
    return [children objectAtIndex:index];
}

- (NSInteger)outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item
{
    return [[self childrenForItem:item] count];
}

- (id)outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item
{
    DataItem *dataItem = [item representedObject];
    return [dataItem valueForKey:tableColumn.identifier];
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item
{
//    DataItem *dataItem = [item representedObject];
//    return [dataItem.children count] > 0;
    return [[item childNodes] count] > 0;
}

- (void)outlineView: (NSOutlineView *)ov setObjectValue: (id)object forTableColumn: (NSTableColumn *)tableColumn byItem: (id)item
{
    DataItem *dataItem = [item representedObject];
    
    // Here, we manipulate the data stored in the node.
    [dataItem setValue:object forKey:[tableColumn identifier]];
}

#pragma mark =============  OutlineView Delegate ===============
- (void)outlineViewSelectionDidChange:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    id object = [notification object];
}
- (void)outlineViewColumnDidMove:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    id object = [notification object];
}
- (void)outlineViewColumnDidResize:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    id object = [notification object];
}
- (void)outlineViewSelectionIsChanging:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    id object = [notification object];
}
- (void)outlineViewItemWillExpand:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    id object = [notification object];
}
- (void)outlineViewItemDidExpand:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    id object = [notification object];
}
- (void)outlineViewItemWillCollapse:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    id object = [notification object];
}
- (void)outlineViewItemDidCollapse:(NSNotification *)notification
{
    NSDictionary *userInfo = [notification userInfo];
    id object = [notification object];
}

- (void)outlineView:(NSOutlineView *)olv willDisplayCell:(NSCell*)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    DataItem *dataItem = [item representedObject];
    if ([tableColumn.identifier isEqualToString:@"title"]) {
        _cell.name = dataItem.title;
        _cell.image = dataItem.image;
        _cell.selected = dataItem.isSelected;
        //[tableColumn setDataCell:_cell];
    }
    else if ([tableColumn.identifier isEqualToString:@"content"]) {
        [cell setStringValue:dataItem.content];
        //不能再setDataCell, 否则内容会重复
        //[tableColumn setDataCell:cell];
    }
}
//Remove the triangles,but does not remove the space reserved for triangles.
//- (void)outlineView:(NSOutlineView *)outlineView willDisplayOutlineCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
//{
//    [cell setTransparent:NO];
//}

- (NSCell *)outlineView:(NSOutlineView *)outlineView dataCellForTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    if (tableColumn != nil) {
        if ([tableColumn.identifier isEqualToString:@"title"]) {
            return _cell;
        }
        else if ([tableColumn.identifier isEqualToString:@"content"]) {
            return [tableColumn dataCell];
        }
        else{
            return nil;
        }
    }
    else {
        // A nil table column is for a "full width" table column which we don't need (since we only ever have one column)
        return nil;
    }
}

- (CGFloat)outlineView:(NSOutlineView *)outlineView heightOfRowByItem:(id)item
{
    return 40.0;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView isGroupItem:(id)item
{
//    DataItem *dataItem = [item representedObject];
//    return [dataItem.children count] > 0;
    return [[item childNodes] count] > 0;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldSelectItem:(id)item
{
    return YES;
}

- (BOOL)outlineView:(NSOutlineView *)ov shouldTrackCell:(NSCell *)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item
{
    // We want to allow tracking for all the button cells, even if we don't allow selecting that particular row.
    if ([cell isKindOfClass:[NSButtonCell class]]) {
        // We can also take a peek and make sure that the part of the cell clicked is an area that is normally tracked. Otherwise, clicking outside of the checkbox may make it check the checkbox
        NSRect cellFrame = [_outlineView frameOfCellAtColumn:[[_outlineView tableColumns] indexOfObject:tableColumn] row:[_outlineView rowForItem:item]];
        
        NSUInteger hitTestResult = [cell hitTestForEvent:[NSApp currentEvent]
                                                  inRect:cellFrame
                                                  ofView:_outlineView];
        if ((hitTestResult & NSCellHitTrackableArea) != 0) {
            return YES;
        } else {
            return NO;
        }
    } else {
        // Only allow tracking on selected rows. This is what NSTableView does by default.
        return [_outlineView isRowSelected:[_outlineView rowForItem:item]];
    }
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldCollapseItem:(id)item
{
    return [[item childNodes] count] > 0;
}

- (BOOL)outlineView:(NSOutlineView *)outlineView shouldExpandItem:(id)item
{
//    DataItem *dataItem = [item representedObject];
//    return [dataItem.children count] > 0;
     return [[item childNodes] count] > 0;
}

//Return NO and remove the triangles,but does not remove the space reserved for triangles.
- (BOOL)outlineView:(NSOutlineView *)outlineView shouldShowOutlineCellForItem:(id)item
{
//    DataItem *dataItem = [item representedObject];
//    return [dataItem.children count] > 0 ? YES : NO;
    return [[item childNodes] count] > 0 ? YES : NO;
}

@end
