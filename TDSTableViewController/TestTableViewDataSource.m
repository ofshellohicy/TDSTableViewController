//
//  TestTableViewDataSource.m
//  TDSTableViewController
//
//  Created by zhong sheng on 12-6-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TestTableViewDataSource.h"

@implementation TestTableViewDataSource
- (NSString*)titleForError:(NSError*)error{
    return @"title error";
}

- (NSString*)subtitleForError:(NSError*)error{
    return @"subtitle error";    
}
- (UIImage*)imageForError:(NSError*)error{
    return nil;
}
@end
