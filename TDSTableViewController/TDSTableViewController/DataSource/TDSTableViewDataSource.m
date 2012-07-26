//
//  RSCTableViewDataSource.m
//  icePhone
//
//  Created by zhong sheng on 12-5-28.
//  Copyright (c) 2012年 icePhone. All rights reserved.
//

#import "TDSTableViewDataSource.h"
#import "TDSTableViewItem.h"
#import "TDSTableViewCell.h"
#import "TDSTableView.h"
#import "TDSTableViewLoadMoreCell.h"
#import "TDSTableViewLoadMoreItem.h"


@implementation TDSTableViewDataSource
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc 
{
    [super dealloc];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark UITableViewDataSource


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return 0;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell*)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    id object = [self tableView:tableView objectForRowAtIndexPath:indexPath];
    
    Class cellClass = [self tableView:tableView cellClassForObject:object];
    NSString *className = [cellClass className];
    
    UITableViewCell* cell =
    (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:className];
    if (cell == nil) 
    {
        cell = [[[cellClass alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:className] autorelease];
    }
    
    if ([cell isKindOfClass:[TDSTableViewCell class]]) 
    {
        [(TDSTableViewCell*)cell setObject:object];
        [(TDSTableViewCell*)cell setIndexPath:indexPath];
    }
    
    
    [self tableView:tableView cell:cell willAppearAtIndexPath:indexPath];
    
    return cell;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSArray*)sectionIndexTitlesForTableView:(UITableView*)tableView 
{
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView*)tableView sectionForSectionIndexTitle:(NSString*)title
               atIndex:(NSInteger)sectionIndex 
{
    if (tableView.tableHeaderView) 
    {
        if (sectionIndex == 0)  
        {
            // This is a hack to get the table header to appear when the user touches the
            // first row in the section index.  By default, it shows the first row, which is
            // not usually what you want.
            [tableView scrollRectToVisible:tableView.tableHeaderView.bounds animated:NO];
            return -1;
        }
    }
    
    NSString* letter = [title substringToIndex:1];
    NSInteger sectionCount = [tableView numberOfSections];
    for (NSInteger i = 0; i < sectionCount; ++i) 
    {
        NSString* section  = [tableView.dataSource tableView:tableView titleForHeaderInSection:i];
        if ([section hasPrefix:letter]) 
        {
            return i;
        }
    }
    if (sectionIndex >= sectionCount) 
    {
        return sectionCount-1;
        
    }
    else
    {
        return sectionIndex;
    }
}

#pragma mark -
#pragma mark TDSTableViewDataSource

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id)tableView:(UITableView*)tableView objectForRowAtIndexPath:(NSIndexPath*)indexPath 
{
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (Class)tableView:(UITableView*)tableView cellClassForObject:(id)object 
{
	if ([object isKindOfClass:[TDSTableViewLoadMoreItem class]]) 
    {
		return [TDSTableViewLoadMoreCell class];
	}
    if ([object isKindOfClass:[TDSTableViewItem class]]) 
    {
        return [TDSTableViewCell class];
    }      
    return [TDSTableViewCell class];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)tableView:(UITableView*)tableView labelForObject:(id)object 
{
    return @"";
    //    if ([object isKindOfClass:[TTTableTextItem class]]) {
    //        TTTableTextItem* item = object;
    //        return item.text;
    //        
    //    } else {
    //        return [NSString stringWithFormat:@"%@", object];
    //    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSIndexPath*)tableView:(UITableView*)tableView indexPathForObject:(id)object 
{
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView*)tableView cell:(UITableViewCell*)cell 
willAppearAtIndexPath:(NSIndexPath*)indexPath 
{
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)search:(NSString*)text 
{
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForLoading:(BOOL)reloading 
{
    if (reloading) 
    {
        return NSLocalizedString(@"Updating...", @"");        
    } 
    else
    {
        return NSLocalizedString(@"Loading...", @"");
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImage*)imageForEmpty 
{
    return [self imageForError:nil];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForEmpty 
{
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)subtitleForEmpty 
{
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImage*)imageForError:(NSError*)error 
{
    return nil;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)titleForError:(NSError*)error 
{
    return @"error";//TTDescriptionForError(error);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)subtitleForError:(NSError*)error 
{
    return NSLocalizedString(@"Sorry, there was an error.", @"");
}

- (BOOL)empty
{
    return YES;
}


@end
