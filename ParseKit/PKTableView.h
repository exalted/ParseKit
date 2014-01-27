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

#import "NUITableView.h"

#import <Parse/Parse.h>

////////////////////////////////////////////////////////////////////////////////
// Delegate protocol definition
////////////////////////////////////////////////////////////////////////////////
@protocol PKTableViewDelegate <NSObject, NUITableViewDelegate>

@optional

- (void)queryTableView:(UITableView *)tableView didLoadObjects:(NSArray *)objects error:(NSError *)error;

@end

////////////////////////////////////////////////////////////////////////////////
// Data source protocol definition
////////////////////////////////////////////////////////////////////////////////
@protocol PKTableViewDataSource <NSObject, NUITableViewDataSource>

@required

- (PFQuery *)queryForTableView:(UITableView *)tableView;

@end

////////////////////////////////////////////////////////////////////////////////
// Class interface
////////////////////////////////////////////////////////////////////////////////
@interface PKTableView : NUITableView

@property (assign, nonatomic) NSUInteger numberOfObjectsPerPage;

@property (strong, nonatomic, readonly) NSArray *objects;

@property (assign, nonatomic) id<PKTableViewDelegate> delegate;
@property (assign, nonatomic) id<PKTableViewDataSource> dataSource;

@end
