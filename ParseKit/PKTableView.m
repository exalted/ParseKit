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

#import "PKTableView.h"

////////////////////////////////////////////////////////////////////////////////
// Private APIs
////////////////////////////////////////////////////////////////////////////////
@interface PKTableView () <NUITableViewDelegate, NUITableViewDataSource> {
    NSMutableArray *_objects;
}

@end

////////////////////////////////////////////////////////////////////////////////
// Class implementation
////////////////////////////////////////////////////////////////////////////////
@implementation PKTableView

- (NSArray *)objects
{
    return [_objects copy];
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];

//    [super setDelegate:self];
//    [super setDataSource:self];

    self.numberOfObjectsPerPage = 25;
}

#pragma mark - Table view delegate

- (BOOL)shouldReloadDataForTableView:(NUITableView *)tableView
{
    return NO;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

- (void)pullFreshDataForTableView:(NUITableView *)tableView
{
    PFQuery *query = [self.dataSource queryForTableView:self];
    if (query) {
        if (self.paginationEnabled) {
            query.limit = self.numberOfObjectsPerPage;
        }
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (objects && error == nil) {
                _objects = [NSMutableArray arrayWithArray:objects];
            }
            else {
                _objects = nil;
            }
            if ([self.delegate respondsToSelector:@selector(queryTableView:didLoadObjects:error:)]) {
                [self.delegate queryTableView:self didLoadObjects:objects error:error];
            }
            [self reloadData];
        }];
    }
    else {
        [self reloadData];
    }
}

- (void)pullMoreDataForTableView:(NUITableView *)tableView
{
    PFQuery *query = [self.dataSource queryForTableView:self];
    if (query) {
        if (self.paginationEnabled) {
            query.limit = self.numberOfObjectsPerPage;
            query.skip = _objects.count;
        }
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
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
                        }
                        else {
                            [_objects replaceObjectAtIndex:index withObject:object];
                        }
                    }
                }
                else {
                    [_objects addObjectsFromArray:objects];
                }
            }
            if ([self.delegate respondsToSelector:@selector(queryTableView:didLoadObjects:error:)]) {
                [self.delegate queryTableView:self didLoadObjects:objects error:error];
            }
            [self reloadData];
        }];
    }
    else {
        [self reloadData];
    }
}

@end
