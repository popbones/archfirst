//
//  MultiSelectDropdownViewController.m
//  Bullsfirst
//
//  Created by pong choa on 3/12/12.
//  Copyright (c) 2012 KPDS Inc. All rights reserved.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "MultiSelectDropdownViewController.h"

@implementation MultiSelectDropdownViewController
@synthesize selectedSet;
@synthesize selectedCells;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    selectedSet = [[NSMutableSet alloc] init];
    selectedCells = [[NSMutableSet alloc] init];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.selectionsTBL deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    NSString *selectedOption = [self.selections objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [selectedSet removeObject:selectedOption];
            [selectedCells removeObject:cell];
        } else {
            int totalRow = [self.selections count];
            for (int row=0; row<totalRow; row++) {
                NSIndexPath* path = [NSIndexPath indexPathForRow:row inSection:0];
                UITableViewCell *tempCell = [tableView cellForRowAtIndexPath:path];
                tempCell.accessoryType = UITableViewCellAccessoryNone;
            }
            [selectedSet removeAllObjects];
            [selectedCells removeAllObjects];
            
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [selectedSet addObject:@"All"];
            [selectedCells addObject:[tableView cellForRowAtIndexPath:indexPath]];
        }

    } else {
        if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
            cell.accessoryType = UITableViewCellAccessoryNone;
            [selectedSet removeObject:selectedOption];
            [selectedCells removeObject:cell];
        } else {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            [selectedSet addObject:selectedOption];
            [selectedCells addObject:cell];
        }
        NSIndexPath* path = [NSIndexPath indexPathForRow:0 inSection:0];
        UITableViewCell *allOptionCell = [tableView cellForRowAtIndexPath:path];
        if (allOptionCell.accessoryType == UITableViewCellAccessoryCheckmark) {
            allOptionCell.accessoryType = UITableViewCellAccessoryNone;
            [selectedSet removeObject:@"All"];
            [selectedCells removeObject:cell];
        }


    }
    if (self.delegate != nil)
        [self.delegate selectionChanged:self];

}

@end
