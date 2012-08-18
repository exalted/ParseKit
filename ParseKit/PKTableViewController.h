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

#import "NUIKit.h"

#import <Parse/Parse.h>

typedef enum {
    PKQueryObjectsCountChangeError = -1,
    PKQueryObjectsCountChangeFresh,
    PKQueryObjectsCountChangeSame,
    PKQueryObjectsCountChangeMore,
} PKQueryObjectsCountChange;

////////////////////////////////////////////////////////////////////////////////
// Parse query delegate
////////////////////////////////////////////////////////////////////////////////
@protocol PKQueryDelegate <NSObject>

@optional
- (PFQuery *)queryForTableView:(UITableView *)tableView;

- (void)didLoadObjectsForTableView:(UITableView *)tableView countChange:(PKQueryObjectsCountChange)change error:(NSError *)error;

@end

////////////////////////////////////////////////////////////////////////////////
// Class interface
////////////////////////////////////////////////////////////////////////////////
@interface PKTableViewController : NUITableViewController <PKQueryDelegate>

@property (assign, nonatomic) NSUInteger numberOfObjectsPerPage;

@property (strong, readonly, nonatomic) NSArray *objects;

@property (assign, nonatomic) id<PKQueryDelegate> queryDelegate;

@end
