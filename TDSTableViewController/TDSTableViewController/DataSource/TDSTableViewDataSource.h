//
//  RSCTableViewDataSource.h
//  icePhone
//
//  Created by zhong sheng on 12-5-28.
//  Copyright (c) 2012年 icePhone. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TDSTableViewDataSource <UITableViewDataSource, UISearchDisplayDelegate>

- (id)tableView:(UITableView *)tableView objectForRowAtIndexPath:(NSIndexPath *)indexPath;

- (Class)tableView:(UITableView *)tableView cellClassForObject:(id)object;

- (NSString *)tableView:(UITableView *)tableView labelForObject:(id)object;

- (NSIndexPath *)tableView:(UITableView *)tableView indexPathForObject:(id)object;

- (void)tableView:(UITableView *)tableView cell:(UITableViewCell *)cell willAppearAtIndexPath:(NSIndexPath *)indexPath;

- (NSString *)titleForLoading:(BOOL)reloading;

- (UIImage*)imageForEmpty;

- (NSString*)titleForEmpty;

- (NSString*)subtitleForEmpty;

- (UIImage*)imageForError:(NSError*)error;

- (NSString*)titleForError:(NSError*)error;

- (NSString*)subtitleForError:(NSError*)error;

- (BOOL)empty;

@optional

- (NSIndexPath *)tableView:(UITableView *)tableView willUpdateObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)tableView:(UITableView *)tableView willInsertObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)tableView:(UITableView *)tableView willRemoveObject:(id)object atIndexPath:(NSIndexPath *)indexPath;

- (void)search:(NSString *)text;

@end

@interface TDSTableViewDataSource : NSObject <TDSTableViewDataSource>{
    
}


@end
