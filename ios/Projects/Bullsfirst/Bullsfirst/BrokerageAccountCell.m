//
//  BrokerageAccountCell.m
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

#import "BrokerageAccountCell.h"
#import "BFBrokerageAccount.h"
#import "BFMoney.h"

@implementation BrokerageAccountCell
@synthesize delegate;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if(self)
    {
        nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];                
        idLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        marketValueLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        cashLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        editButton = [[UIButton alloc] initWithFrame:CGRectZero];        
        
        [[self contentView] addSubview:nameLabel];
        [[self contentView] addSubview:idLabel];
        [[self contentView] addSubview:marketValueLabel];
        [[self contentView] addSubview:cashLabel];
        [[self contentView] addSubview:editButton];
        
        
    }
    
    return self;
}
-(void) editButtonClicked:(id) sender
{
    [delegate editingStartedForAccount:idLabel.text];
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float insetH = 5.0;
    float insetW = 10.0;
    
    CGRect bounds = [[self contentView] bounds];
    
    float h = bounds.size.height;
    //float w = bounds.size.width;
    
    // TODO: Adjust these values for portrait mode
    float nameWidth = 75.0;
    float idWidth = 70.0;
    float marketValueWidth = 120.0;
    float cashWidth = 120.0;
    float editWidth = 56.0; float editHeight = 31.0;
    
    CGRect nameFrame = CGRectMake(insetW, insetH, nameWidth, h-insetH*2.0);
    [nameLabel setFrame:nameFrame];
    
    CGRect idFrame = CGRectMake(insetW+nameWidth+insetW, insetH, idWidth, h-insetH*2.0);
    [idLabel setFrame:idFrame];
    
    CGRect marketValueFrame = CGRectMake(insetW+nameWidth+insetW+idWidth+insetW, insetH, marketValueWidth, h-insetH*2.0);
    [marketValueLabel setFrame:marketValueFrame];
    
    CGRect cashFrame = CGRectMake(insetW+nameWidth+insetW+idWidth+insetW+marketValueWidth+insetW, insetH, cashWidth, h-insetH*2.0);
    [cashLabel setFrame:cashFrame];
    
    CGRect editFrame = CGRectMake(insetW+nameWidth+insetW+idWidth+insetW+marketValueWidth+insetW+cashWidth+insetW, insetH, editWidth, editHeight);
    [editButton setFrame:editFrame];
    [editButton addTarget:self action:@selector(editButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setBrokerageAccount:(BFBrokerageAccount *)account
{
    NSString *currencySymbol;
    
    if([[[account marketValue] currency] isEqual:@"USD"])
    {
        currencySymbol = @"$";
    }
    
    [nameLabel setText:[account name]];
    [idLabel setText:[[account brokerageAccountID] stringValue]];
    [marketValueLabel setText:[NSString stringWithFormat:@"%@%@", currencySymbol, [[account marketValue] amount]]];
    [cashLabel setText:[NSString stringWithFormat:@"%@%@", currencySymbol, [[account cashPosition] amount]]];
    
    [editButton setBackgroundImage:[UIImage imageNamed:@"btn_edit_56x31.png"] forState:UIControlStateNormal];
}

@end
