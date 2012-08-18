//
// Copyright (C) 2012 Ali Servet Donmez. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import "PKTableViewController.h"

////////////////////////////////////////////////////////////////////////////////
// Private APIs
////////////////////////////////////////////////////////////////////////////////
@interface PKTableViewController () {
    NSMutableArray *_objects;
}

@end

////////////////////////////////////////////////////////////////////////////////
// Class implementation
////////////////////////////////////////////////////////////////////////////////
@implementation PKTableViewController

@synthesize numberOfObjectsPerPage = _numberOfObjectsPerPage;

@synthesize objects = _objects;

@synthesize queryDelegate = _queryDelegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _numberOfObjectsPerPage = 25;
        _queryDelegate = self;
    }
    return self;
}

#pragma mark - Table view delegate

- (BOOL)shouldReloadDataForTableView:(NUITableView *)tableView
{
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.objects.count;
}

- (void)pullFreshDataForTableView:(NUITableView *)tableView
{
    if ([self.queryDelegate respondsToSelector:@selector(queryForTableView:)]) {
        PFQuery *query = [self.queryDelegate queryForTableView:self.tableView];
        if (query) {
            if (self.tableView.paginationEnabled) {
                query.limit = self.numberOfObjectsPerPage;
            }
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                PKQueryObjectsCountChange change = PKQueryObjectsCountChangeFresh;
                if (objects && error == nil) {
                    _objects = [NSMutableArray arrayWithArray:objects];
                }
                else {
                    _objects = nil;
                    change = PKQueryObjectsCountChangeError;
                }
                if ([self.queryDelegate respondsToSelector:@selector(didLoadObjectsForTableView:countChange:error:)]) {
                    [self.queryDelegate didLoadObjectsForTableView:self.tableView countChange:change error:error];
                }
                [self.tableView reloadData];
            }];
        }
        else {
            [self.tableView reloadData];
        }
    }
    else {
        [self.tableView reloadData];
    }
}

- (void)pullMoreDataForTableView:(NUITableView *)tableView
{
    if ([self.queryDelegate respondsToSelector:@selector(queryForTableView:)]) {
        PFQuery *query = [self.queryDelegate queryForTableView:self.tableView];
        if (query) {
            if (self.tableView.paginationEnabled) {
                query.limit = self.numberOfObjectsPerPage;
                query.skip = self.objects.count;
            }
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                PKQueryObjectsCountChange change = PKQueryObjectsCountChangeSame;
                if (objects && error == nil) {
                    if (query.cachePolicy == kPFCachePolicyCacheThenNetwork) {
                        for (PFObject *object in objects) {
                            NSUInteger index = [_objects indexOfObjectWithOptions:NSEnumerationConcurrent|NSEnumerationReverse
                                                                      passingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
                                                                          BOOL found = [[(PFObject *)obj objectId] isEqualToString:object.objectId];
                                                                          stop = &found;
                                                                          return found;
                                                                      }];
                            if (index == NSNotFound) {
                                [_objects addObject:object];
                                change = PKQueryObjectsCountChangeMore;
                            }
                            else {
                                [_objects replaceObjectAtIndex:index withObject:object];
                            }
                        }
                    }
                    else {
                        [_objects addObjectsFromArray:objects];
                        change = PKQueryObjectsCountChangeMore;
                    }
                }
                if ([self.queryDelegate respondsToSelector:@selector(didLoadObjectsForTableView:countChange:error:)]) {
                    [self.queryDelegate didLoadObjectsForTableView:self.tableView countChange:change error:error];
                }
                [self.tableView reloadData];
            }];
        }
        else {
            [self.tableView reloadData];
        }
    }
    else {
        [self.tableView reloadData];
    }
}

@end
