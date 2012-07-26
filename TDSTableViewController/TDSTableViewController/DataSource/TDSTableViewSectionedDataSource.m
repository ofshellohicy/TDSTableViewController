//
//  RSSectionedDataSource.m
//  icePhone
//
//  Created by zhong sheng on 12-5-31.
//  Copyright (c) 2012年 icePhone. All rights reserved.
//

#import "TDSTableViewSectionedDataSource.h"
#import "TDSTableViewItem.h"
#import "TDSTableViewSectionObject.h"
#import "TDSTextTableViewItem.h"
#import "TDSTextTableViewCell.h"

@interface TDSTableViewSectionedDataSource(Pirvate)

- (BOOL)removeItemAtIndexPath:(NSIndexPath *)indexPath andSectionIfEmpty:(BOOL)andSection;

@end
@implementation TDSTableViewSectionedDataSource
@synthesize sections			= _sections;
@synthesize firstSectionItems	= _firstSectionItems;

// /////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc
{
	self.sections = nil;
	[super dealloc];
}

- (NSArray *)firstSectionItems
{
	if ((_sections == nil) || (_sections.count <= 0)) {
		return nil;
	}

	TDSTableViewSectionObject *firstObj = [_sections objectAtIndex:0];
	return firstObj.items;
}

- (BOOL)empty
{
    return self.sections == nil || self.sections.count <= 0;
}

#pragma mark -
#pragma mark Class public
- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object
{
    if ([object isKindOfClass:[TDSTextTableViewItem class]]) {
        return [TDSTextTableViewCell class];
    }
    return [TDSTableViewCell class];
}
#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return _sections ? _sections.count : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (_sections && _sections.count > section) {
		TDSTableViewSectionObject *sectionObject = [_sections objectAtIndex:section];
		return sectionObject.items.count;
	}

	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	if (_sections.count) {
		TDSTableViewSectionObject *sectionObject = [_sections objectAtIndex:section];
        if (sectionObject.letter) {
            return sectionObject.letter;            
        }
	} 
    return nil;
}

#pragma mark -
#pragma mark TDSTableViewDataSource

- (id)tableView:(UITableView *)tableView objectForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (_sections) {
		TDSTableViewSectionObject *aSectionObject = [_sections objectAtIndex:indexPath.section];

		if ([aSectionObject.items count] > 0) {
			return [aSectionObject.items objectAtIndex:indexPath.row];
		}
	}

	return nil;
}

- (NSIndexPath *)tableView:(UITableView *)tableView indexPathForObject:(id)object
{
	if (_sections) {
		for (int i = 0; i < _sections.count; ++i) {
			TDSTableViewSectionObject	*aSectionObject = [_sections objectAtIndex:i];
			NSUInteger					objectIndex		= [aSectionObject.items indexOfObject:object];

			if (objectIndex != NSNotFound) {
				return [NSIndexPath indexPathForRow:objectIndex inSection:i];
			}
		}
	}

	return nil;
}

#pragma mark -
#pragma mark Public

- (NSIndexPath *)indexPathOfItemWithUserInfo:(id)userInfo
{
	if (_sections.count) {
		for (NSInteger i = 0; i < _sections.count; ++i) {
			TDSTableViewSectionObject *sectionObject = [_sections objectAtIndex:i];

			for (NSInteger j = 0; j < sectionObject.items.count; ++j) {
				TDSTableViewItem *item = [sectionObject.items objectAtIndex:j];

				if (item.userInfo == userInfo) {
					return [NSIndexPath indexPathForRow:j inSection:i];
				}
			}
		}
	}

	return nil;
}

- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath
{
	[self removeItemAtIndexPath:indexPath andSectionIfEmpty:NO];
}

- (BOOL)removeItemAtIndexPath:(NSIndexPath *)indexPath andSectionIfEmpty:(BOOL)andSection
{
	if (_sections.count) {
		TDSTableViewSectionObject *sectionObject = [_sections objectAtIndex:indexPath.section];
		[sectionObject.items removeObjectAtIndex:indexPath.row];

		if (andSection && !sectionObject.items.count) {
			[_sections removeObjectAtIndex:indexPath.section];
			return YES;
		}
	}

	return NO;
}
- (NSIndexPath *)tableView:(UITableView *)tableView willUpdateObject:(id)object atIndexPath:(NSIndexPath *)indexPath
{
    if (_sections.count > indexPath.section) {
        TDSTableViewSectionObject *sectionObject = [_sections objectAtIndex:indexPath.section];        
        if (sectionObject.items.count > indexPath.row) {
            [sectionObject.items replaceObjectAtIndex:indexPath.row withObject:object];
        }        
    }
    return indexPath;
}

@end