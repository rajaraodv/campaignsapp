//
//  CampaignMembersViewController.h
//  CampaignsApp
//
//  Created by Raja Rao DV on 2/2/14.
//  Copyright (c) 2014 Sample Apps from Salesforce. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SFRestAPI.h"
#import "CustomCell.h"
@interface CampaignMembersViewController : UITableViewController <SFRestDelegate,EnterAmountDelegate> {
    int selectedRowIndex;
}


@property (nonatomic, strong) NSDictionary *campaignObject;
@property (nonatomic, strong) NSMutableArray *dataRows;
@property (nonatomic, strong) NSMutableArray *filterResults;
@property (strong, nonatomic) IBOutlet UISearchBar *filterField;

- (void)updateCheckInStatus:(NSString *)objectType
                   objectId:(NSString *)objectId
                  newStatus:(NSString *)newStatus;
@end
