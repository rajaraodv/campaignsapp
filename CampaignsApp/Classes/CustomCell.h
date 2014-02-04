//
//  CustomCell.h
//  CampaignsApp
//
//  Created by Raja Rao DV on 2/2/14.
//  Copyright (c) 2014 Sample Apps from Salesforce. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol EnterAmountDelegate <NSObject>;

-(void)amountEntered:(id) cell;

@end

@interface CustomCell : UITableViewCell


@property (nonatomic,strong) id <EnterAmountDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *memberName;

@property (strong, nonatomic) IBOutlet UILabel *emailLabel;
@property (strong, nonatomic) IBOutlet UILabel *phoneLabel;
@property (strong, nonatomic) IBOutlet UISwitch *checkInSwitch;
@property (strong, nonatomic) IBOutlet UILabel *checkInLabel;

- (IBAction)toggleAction:(id)sender;

@end
