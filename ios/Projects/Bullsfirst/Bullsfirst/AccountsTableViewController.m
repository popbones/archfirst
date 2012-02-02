//
//  AccountsTableViewController.m
//  Bullsfirst
//
//  Created by Joe Howard
//  Copyright 2012 Archfirst
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

#import "AccountsTableViewController.h"
#import "BFBrokerageAccountStore.h"
#import "BFBrokerageAccount.h"

@implementation AccountsTableViewController

@synthesize delegate;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BFBrokerageAccountStore defaultStore] allBrokerageAccounts] count];
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    
    BFBrokerageAccount *account = [[[BFBrokerageAccountStore defaultStore] allBrokerageAccounts] objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:[account name]];
    
    return cell;
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BrokerageAccountCell *cell = (BrokerageAccountCell *)[tableView dequeueReusableCellWithIdentifier:@"BrokerageAccountCell"];
    
    if(!cell)
    {
        cell = [[BrokerageAccountCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BrokerageAccountCell"]; 
        [cell setDelegate:self];
    }
    
    
    NSArray *brokerageAccounts = [[BFBrokerageAccountStore defaultStore] allBrokerageAccounts];
    BFBrokerageAccount *account = [brokerageAccounts objectAtIndex:[indexPath row]];
    
    [cell setBrokerageAccount:account];
    
    return cell;
}

#pragma mark BrokerageAccountCell Delegate methods

-(void) editingStartedForAccount:(NSString *)oldAccountName
{
    [delegate editingStartedForAccountWithName:oldAccountName];
}

@end



