//
//  AppDelegate.m
//  Cocoa Outline View
//
//  Created by Nikola Grujic on 31/01/2020.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)awakeFromNib
{
    outlineViewData = [[NSMutableDictionary alloc] init];
    
    [self setDataSource];
    [self setDelegate];
    
    [self fillTestData];
}

- (void)setDataSource
{
    [_outlineView setDataSource:(id)self];
}

- (void)setDelegate
{
    [_outlineView setDelegate:self];
}

#pragma mark NSOutlineViewDataSource methods

// Returns the number of child items encompassed by a given item.
- (NSInteger)outlineView:(NSOutlineView *)outlineView
  numberOfChildrenOfItem:(id)item
{
    if (item == nil)
    {
        return [outlineViewData count];
    }
    
    return [item count];
}

// Returns the child item at the specified index of a given item.
- (id)outlineView:(NSOutlineView *)outlineView
            child:(NSInteger)index
           ofItem:(id)item
{
    if (item == nil)
    {
        item = outlineViewData;
    }
    
    if ([item isKindOfClass:[NSArray class]])
    {
        return [item objectAtIndex:index];
    }
    else if ([item isKindOfClass:[NSDictionary class]])
    {
        NSArray *keys = [item allKeys];
        return [item objectForKey:[keys objectAtIndex:index]];
    }
    
    return nil;
}

// Implemented to return the view used to display the specified item and column.
- (NSView *)outlineView:(NSOutlineView *)outlineView
     viewForTableColumn:(NSTableColumn *)tableColumn
                   item:(id)item
{
    bool isFirstColumn = [[tableColumn identifier] isEqualToString:@"firstColumn"];
    
    if (!isFirstColumn)
    {
        return nil;
    }

    NSTableCellView *cell = [outlineView makeViewWithIdentifier:@"firstColumn" owner:self];
    
    NSButton *cellButton = (NSButton*)cell;
    NSString *itemName = [self getItemName:item];
    [cellButton setTitle:itemName];
    [cellButton setAction:@selector(itemChecked:)];
    
    return cell;
}

// Returns a Boolean value that indicates whether the a given item is expandable.
- (BOOL)outlineView:(NSOutlineView *)outlineView
   isItemExpandable:(id)item
{
    if ([item isKindOfClass:[NSArray class]] || [item isKindOfClass:[NSDictionary class]])
    {
        if ([item count] > 0)
        {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark Action methods

- (IBAction)itemChecked:(id)sender
{
    NSButton *checkedCellButton = (NSButton*)sender;
    NSString *checkedCellName = [checkedCellButton title];
    
    long checkedCellIndex = [_outlineView rowForView:sender];
    id itemAtRow = [_outlineView itemAtRow:checkedCellIndex];
    id parent = [self findParentForItem:itemAtRow];
    
    if (parent == nil)
    {
        NSLog(@"%ld: %@", checkedCellIndex, checkedCellName);
    }
    else
    {
        NSLog(@"%ld: %@ %@", checkedCellIndex, checkedCellName, parent);
    }
}

#pragma mark Helper methods

- (void)fillTestData
{
    // Item 1
    NSArray *items = [NSArray arrayWithObjects:@"Liverpool", @"Manchester City", @"Chelsea", @"Manchester United", nil];
    [outlineViewData setObject:items forKey:@"England"];
    
    // Item 2
    items = [NSArray arrayWithObjects:@"Juventus", @"Roma", @"Milan", @"Inter Milan", nil];
    [outlineViewData setObject:items forKey:@"Italy"];
    
    // Item 3
    items = [NSArray arrayWithObjects:@"Real Madrid", @"Barcelona", @"Atletico Madrid", @"Valencia", nil];
    [outlineViewData setObject:items forKey:@"Spain"];
    
    [_outlineView reloadData];
}

- (id)findParentForItem:(id)item
{
    NSArray *parentArray = (NSArray*)[_outlineView parentForItem:item];
    
    for(id key in outlineViewData)
    {
        id value = [outlineViewData objectForKey:key];
        
        if (value == parentArray)
        {
            return key;
        }
    }
    
    return nil;
}

- (NSString*)getItemName:(id)item
{
    NSString *itemName;
    
    if ([item isKindOfClass:[NSString class]])
    {
        itemName = item;
    }
    else if ([item isKindOfClass:[NSArray class]])
    {
        NSArray *keys = [outlineViewData allKeysForObject:item];

        itemName = [keys objectAtIndex:0];
    }
    else
    {
        itemName = @"";
    }
    
    return itemName;
}

@end

