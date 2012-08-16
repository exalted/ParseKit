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

#import "PKFirstViewController.h"

@interface PKFirstViewController ()

@end

@implementation PKFirstViewController

#pragma mark - Query delegate

- (PFQuery *)queryForTableView:(UITableView *)tableView
{
    PFQuery *query = [PFQuery queryWithClassName:@"TestObject"];
    [query orderByAscending:@"title"];
    return query;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    PFObject *object = [self.objects objectAtIndex:indexPath.row];

    // Configure the cell...
    cell.textLabel.text = [object objectForKey:@"title"];

    return cell;
}

@end
