//
//  TabelViewCellTestCtrl.m
//  CustomControl
//
//  Created by 沧海无际 on 14-5-11.
//  Copyright (c) 2014年 liww. All rights reserved.
//

#import "TabelViewCellTestCtrl.h"
#import "ATDesktopEntity.h"
#import "ATColorCell.h"
#import "ATImageTextCell.h"
#import "ImageTextCell.h"
#import "ImageTextCheckboxCell.h"

@interface TabelViewCellTestCtrl ()

@end

@implementation TabelViewCellTestCtrl

- (id)init
{
    self = [super initWithWindowNibName:@"TabelViewCellTestCtrl" owner:self];
    if (self) {
        _tableContents = nil;
        
        _sharedGroupTitleCell = [[NSTextFieldCell alloc] init];
        _imageTextCell = [[ImageTextCell alloc] init];
        _ATImageTextCell = [[ATImageTextCell alloc] init];
        _imageTextCheckboxCell = [[ImageTextCheckboxCell alloc] init];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(checkboxStateDidChanged:)
                                                     name:@"CheckboxStateDidChanged"
                                                   object:nil];
        
        [self createTableContents];
        [self createTableView];
    }
    return self;
}

- (id)init2
{
    self = [super init];
    if (self) {
        if ([[NSBundle mainBundle] respondsToSelector:@selector(loadNibNamed:owner:topLevelObjects:)]) {
            // We're running on Mountain Lion or higher
            [[NSBundle mainBundle] loadNibNamed:@"TabelViewCellTestCtrl"
                                          owner:self
                                topLevelObjects:nil];
        } else {
            // We're running on Lion
            [NSBundle loadNibNamed:@"TabelViewCellTestCtrl"
                             owner:self];
        }
        _tableContents = nil;
        
        _sharedGroupTitleCell = [[NSTextFieldCell alloc] init];
        
        _imageTextCell = [[ImageTextCell alloc] init];
        _ATImageTextCell = [[ATImageTextCell alloc] init];
        _imageTextCheckboxCell = [[ImageTextCheckboxCell alloc] init];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(checkboxStateDidChanged:)
                                                     name:@"CheckboxStateDidChanged"
                                                   object:nil];
        
    }
    return self;
}



- (void)dealloc
{
    [_tableContents         release]; _tableContents = nil;
    [_imageTextCell         release]; _imageTextCell = nil;
    [_ATImageTextCell       release]; _ATImageTextCell = nil;
    [_imageTextCheckboxCell release]; _imageTextCheckboxCell = nil;
    [_sharedGroupTitleCell  release]; _sharedGroupTitleCell = nil;
    
    [super dealloc];
}

- (void)awakeFromNib
{
    
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    [_lzTableView reloadData];
    
    [_lzTableView selectRowIndexes:[NSIndexSet indexSetWithIndex:1] byExtendingSelection:NO];
}

- (void)createTableView
{
    NSScrollView *tableContainer = [[NSScrollView alloc] initWithFrame:NSMakeRect(10, 10, 612, 390)];
    _lzTableView = [[LZTableView alloc] init];
    
    NSSortDescriptor *sortDescriptor = nil;
    
    
    NSTableColumn *column1 = [[NSTableColumn alloc] initWithIdentifier:@"column1"];
    [column1.headerCell setTitle:@"ImageTextCell"];
    [column1 setWidth:120];
    [column1 setEditable:YES];
    
    NSTableColumn *column2 = [[NSTableColumn alloc] initWithIdentifier:@"column2"];
    [column2.headerCell setTitle:@"ATImageTextCell"];
    [column2 setWidth:300];
    [column2 setEditable:YES];
    
    NSTableColumn *column3 = [[NSTableColumn alloc] initWithIdentifier:@"column3"];
    [column3.headerCell setTitle:@"ImageTextCheckboxCell"];
    [column3 setWidth:150];
    [column3 setEditable:YES];
    
    
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title"
                                                 ascending:YES
                                                  selector:@selector(caseInsensitiveCompare:)];
    
    [column3 setSortDescriptorPrototype:sortDescriptor];
    
    [sortDescriptor release]; sortDescriptor = nil;
    
    
    [_lzTableView addTableColumn:column1];
    [_lzTableView addTableColumn:column2];
    [_lzTableView addTableColumn:column3];
    
    [_lzTableView setDelegate:self];
    [_lzTableView setDataSource:self];
    
    
    //embed the table view in the scroll view, and add the scroll view to our window.
    [tableContainer setDocumentView:_lzTableView];
    [tableContainer setHasVerticalScroller:YES];
    [tableContainer setHasHorizontalScroller:YES];
    [self.window.contentView addSubview:tableContainer];
    
    [tableContainer release];
    [column1 release];
    [column2 release];
    [column3 release];
}

- (void)createTableContents
{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    NSURL *url = [NSURL fileURLWithPath:@"/Library/Desktop Pictures" isDirectory:YES];
    ATDesktopFolderEntity *primaryFolder = [[ATDesktopFolderEntity alloc] initWithFileURL:url];
    
    
    // Create a flat array of ATDesktopFolderEntity and ATDesktopImageEntity objects to display
    _tableContents = [[NSMutableArray alloc] init];
    
    
    // We first do a pass over the children and add all the images under the "Desktop Pictures" category
    [_tableContents addObject:primaryFolder];
    for (ATDesktopEntity *entity in primaryFolder.children) {
        if ([entity isKindOfClass:[ATDesktopImageEntity class]]) {
            [_tableContents addObject:entity];
        }
    }
    
    
    // Then do another pass through and add all the folders -- including their children.
    // A recursive loop could be used too, but we want to only go one level deep
    for (ATDesktopEntity *entity in primaryFolder.children) {
        if ([entity isKindOfClass:[ATDesktopFolderEntity class]]) {
            [_tableContents addObject:entity];
            ATDesktopFolderEntity *subFolder = (ATDesktopFolderEntity *)entity;
            for (ATDesktopEntity *subFolderChildEntity in subFolder.children) {
                if ([subFolderChildEntity isKindOfClass:[ATDesktopImageEntity class]]) {
                    [_tableContents addObject:subFolderChildEntity];
                }
            }
        }
    }
    
    [primaryFolder release];
    
    
    for (ATDesktopEntity *imageEntity in _tableContents) {
        if ([imageEntity isKindOfClass:[ATDesktopImageEntity class]]) {
            [(ATDesktopImageEntity *)imageEntity loadImage];
        }
    }
    
    [pool drain];
}


#pragma mark ----------------------table view delegate------------------------
- (void)checkboxStateDidChanged:(NSNotification *)note
{
    NSInteger editingRow = [_lzTableView clickedRow];
//    NSInteger editingColumn = [_lzTableView clickedColumn];
//    NSTableColumn *tableColumn = editingColumn != -1 ? [_lzTableView.tableColumns objectAtIndex:editingColumn] : nil;
    
    ATDesktopImageEntity *entity = (ATDesktopImageEntity *)[self _entityForRow:editingRow];
    [entity setSelected:![entity isSelected]];
    
//    [_lzTableView reloadDataForRowIndexes:[NSIndexSet indexSetWithIndex:editingRow] columnIndexes:[NSIndexSet indexSetWithIndex:editingColumn]];
    
    [_lzTableView reloadData];
}

- (ATDesktopEntity *)_entityForRow:(NSInteger)row
{
    return (ATDesktopEntity *)[_tableContents objectAtIndex:row];
}

- (ATDesktopImageEntity *)_imageEntityForRow:(NSInteger)row
{
    id result = (row != -1 ? [_tableContents objectAtIndex:row] : nil);
    if ([result isKindOfClass:[ATDesktopImageEntity class]]) {
        return result;
    }
    return nil;
}

#pragma mark datasource
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return _tableContents == nil? 0 : _tableContents.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return [self _entityForRow:row].title;
    //return [[self _entityForRow:row] valueForKey:@"title"];
}

- (void)tableView:(NSTableView *)aTableView setObjectValue:(id)anObject forTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
    if ([[aTableColumn identifier] isEqualToString:@"column3"]) {
        ATDesktopImageEntity *entity = [self _imageEntityForRow:rowIndex];
        [_tableContents replaceObjectAtIndex:rowIndex withObject:entity];
    }
}


#pragma mark delegate
- (void)tableView:(NSTableView *)tableView
  willDisplayCell:(id)cell
   forTableColumn:(NSTableColumn *)tableColumn
              row:(NSInteger)row
{
    ATDesktopImageEntity *entity = [self _imageEntityForRow:row];
    
    if (entity != nil) {
        
        // Setup the image and fill color
        if ([tableColumn.identifier isEqualToString:@"column1"]) {
            //ImageTextCell *_imageTextCell = (ImageTextCell *)cell;
            _imageTextCell.image = entity.thumbnailImage;
            
            [tableColumn setDataCell:_imageTextCell];
        }
        else if ([tableColumn.identifier isEqualToString:@"column2"]){
            //ATImageTextCell *_ATImageTextCell = (ATImageTextCell *)cell;
            _ATImageTextCell.image = entity.thumbnailImage;
            _ATImageTextCell.fillColor = entity.fillColor;
            _ATImageTextCell.fillColorName = entity.fillColorName;
            
            [tableColumn setDataCell:_ATImageTextCell];
        }
        else if ([tableColumn.identifier isEqualToString:@"column3"]){
            //ImageTextCheckboxCell *myCell = (ImageTextCheckboxCell *)cell;
            _imageTextCheckboxCell.image = entity.thumbnailImage;
            _imageTextCheckboxCell.name = entity.title;
            _imageTextCheckboxCell.selected = entity.isSelected;
            
            [_imageTextCheckboxCell setEditable:YES];
            [_imageTextCheckboxCell setSelectable:YES];
            
            //设置NSTextFieldCell背景色
            if ((row % 2) != 0){
                [_imageTextCheckboxCell setDrawsBackground:YES];
                [_imageTextCheckboxCell setBackgroundColor:[NSColor colorWithCalibratedRed:2.0 / 255.0
                                                                     green:243.0 / 255.0
                                                                      blue:254.0 / 255.0
                                                                     alpha:1.0]];
            }
            else{
                [_imageTextCheckboxCell setDrawsBackground: NO];
            }
            
            [tableColumn setDataCell:_imageTextCheckboxCell];
        }
    }
    
    [_lzTableView setNeedsDisplay:YES];
}


// We want a regular text field cell that we setup in the nib for the group rows, and the default one setup for the tablecolumn for all others
- (NSCell *)tableView:(NSTableView *)tableView dataCellForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if (tableColumn != nil) {
        if ([[self _entityForRow:row] isKindOfClass:[ATDesktopFolderEntity class]]) {
            
            // Use a shared cell setup in IB via an IBOutlet
            return _sharedGroupTitleCell;
        }
        else {
            return [tableColumn dataCell];
        }
    }
    else {
        // A nil table column is for a "full width" table column which we don't need (since we only ever have one column)
        return nil;
    }
}


// We make the "group rows" have the standard height, while all other image rows have a larger height
- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    if ([[self _entityForRow:row] isKindOfClass:[ATDesktopFolderEntity class]]) {
        return [tableView rowHeight];
    }
    else{
        return 120.0;
    }
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSLog(@"tableViewSelectionDidChange");
}

- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row
{
    NSLog(@"tableView:isGroupRow:");
    if ([[self _entityForRow:row] isKindOfClass:[ATDesktopFolderEntity class]]) {
        return YES;
    }
    else {
        return NO;
    }
}

//是否可以选择
- (BOOL)selectionShouldChangeInTableView:(NSTableView *)tableView
{
    return YES;
}

//指定的行是否可以选择
- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    
    return YES;
}

//If implemented, this method will be called instead of tableView:shouldSelectRow:.
//- (NSIndexSet *)tableView:(NSTableView *)tableView selectionIndexesForProposedSelection:(NSIndexSet *)proposedSelectionIndexes
//{
//    return proposedSelectionIndexes;
//}

//指定的列是否可以选择
- (BOOL)tableView:(NSTableView *)tableView shouldSelectTableColumn:(NSTableColumn *)tableColumn
{
    if ([tableColumn.identifier isEqualToString:@"column1"]) {
        return NO;
    }
    return YES;
}

//Asks the delegate whether the specified cell should be tracked.
- (BOOL)tableView:(NSTableView *)tableView shouldTrackCell:(NSCell *)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    if ([tableColumn.identifier isEqualToString:@"column1"]) {
        return NO;
    }
    return YES;
}

//Asks the delegate if the cell at the specified row and column can be edited.
- (BOOL)tableView:(NSTableView *)aTableView shouldEditTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex
{
    if ([tableColumn.identifier isEqualToString:@"column1"]) {
        return NO;
    }
    return YES;
}

//排序
- (void)tableView:(NSTableView *)atableView sortDescriptorsDidChange:(NSArray *)oldDescriptors
{
    NSArray *newDescriptors = [atableView sortDescriptors];
    [_tableContents sortUsingDescriptors:newDescriptors];
    [_lzTableView reloadData];
}
@end
