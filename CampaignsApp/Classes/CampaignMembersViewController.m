//
//  CampaignMembersViewController.m
//  CampaignsApp
//
//  Created by Raja Rao DV on 2/2/14.
//  Copyright (c) 2014 Sample Apps from Salesforce. All rights reserved.
//

#import "CampaignMembersViewController.h"

@interface CampaignMembersViewController ()

@end

@implementation CampaignMembersViewController


- (id)initWithStyle:(UITableViewStyle)style
{

    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)filterCampaignMemberResults {
    self.filterResults = nil;
    NSMutableArray *_fr = [[NSMutableArray alloc] init];
    
    //add a custom filter logic
    for(NSDictionary *campaignMember in self.dataRows) {
        NSDictionary *leadOrContact = [campaignMember objectForKey:@"Lead"];
        NSString *type = @"Lead";
        if(leadOrContact == (id)[NSNull null]) {
            type = @"Contact";
            leadOrContact = [campaignMember objectForKey:@"Contact"];
        }
        
        if([[leadOrContact objectForKey:@"Name"] rangeOfString:self.filterField.text options:NSCaseInsensitiveSearch].location != NSNotFound) {
            [_fr addObject: campaignMember];
        }
    }
    self.filterResults = _fr;
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterCampaignMemberResults];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hack_checkin_bg.png"]];
//    imageView.alpha = 0.2;
//    self.tableView.backgroundView = imageView;
//    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hack_checkin_bg.png"]];
//    imageView2.alpha = 0.2;
//    [self.searchDisplayController searchResultsTableView].backgroundView = imageView2;
    
    //register main table view's xib file
    [self.tableView registerNib:[UINib nibWithNibName:@"View"
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"campaignMemberCellID"];
    
    //register search table view's xib file
    UITableView *searchTableView = [self.searchDisplayController searchResultsTableView];
    [searchTableView registerNib:[UINib nibWithNibName:@"View"
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"campaignMemberCellID"];

    
    //register height of search table view..
    self.searchDisplayController.searchResultsTableView.rowHeight = self.tableView.rowHeight;


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [self.tableView registerNib:[UINib nibWithNibName:@"View"
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"campaignMemberCellID"];
    
    [super viewWillAppear:animated];
    self.title = [self.campaignObject objectForKey:@"Name"];
    selectedRowIndex = -1;

    
    // alert = [[UIAlertView alloc] initWithTitle: @"Loading..." message: nil delegate:self cancelButtonTitle: nil otherButtonTitles: nil];
    // [alert show];
    
    // Here we use a query that should work on either Force.com or Database.com.
    [self queryCampaignMembers];
}

- (void) queryCampaignMembers {
    NSString *query = @"SELECT Id,status,lead.name,lead.email,lead.phone,lead.id,contact.name,contact.id,contact.email,contact.phone FROM CampaignMember Where CampaignId = '%@'";
    query = [NSString stringWithFormat:query, [self.campaignObject objectForKey:@"Id"]];
    
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:query];
    [[SFRestAPI sharedInstance] send:request delegate:self];
}

- (void)updateCheckInStatus:(NSString *)objectType
            objectId:(NSString *)objectId
            newStatus:(NSString *)newStatus
{
    NSDictionary *fields = [NSDictionary dictionaryWithObjectsAndKeys:
                            newStatus, @"status",
                            nil];
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForUpdateWithObjectType:objectType
                                                                               objectId:objectId
                                                                                 fields:fields];
    [[SFRestAPI sharedInstance] send:request delegate:self];
}

#pragma mark - SFRestAPIDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    NSString *q = [request.queryParams objectForKey:@"q"];
    if(q != nil && [q rangeOfString:@"lead.name"].location != NSNotFound) {
        NSMutableArray *records = [jsonResponse objectForKey:@"records"];
        self.dataRows = records;
        
        [self.tableView reloadData];
    } else {
        [self queryCampaignMembers];
    }
}

- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    //[alert dismissWithClickedButtonIndex:0 animated:YES];
    
    NSLog(@"request:didFailLoadWithError: %@", error);
    //add your failed error handling here
}

- (void)requestDidCancelLoad:(SFRestRequest *)request {
    NSLog(@"requestDidCancelLoad: %@", request);
    //add your failed error handling here
}

- (void)requestDidTimeout:(SFRestRequest *)request {
    //[alert dismissWithClickedButtonIndex:0 animated:YES];
    
    NSLog(@"requestDidTimeout: %@", request);
    //add your failed error handling here
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

//called to set cell's style
- (void) tableView:(UITableView *)tblview willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //    cell.textLabel.numberOfLines = 0;
    //    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
    //cell.backgroundColor = [UIColor clearColor];
    //cell.backgroundView.backgroundColor = [UIColor clearColor];
}

- (NSInteger)tableView:(UITableView *)tblView numberOfRowsInSection:(NSInteger)section
{
    if(tblView == self.tableView) {
        return [self.dataRows count];
    } else {
        [self filterCampaignMemberResults];
        return [self.filterResults count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"campaignMemberCellID";

    // Dequeue or create a cell of the appropriate type.
    CustomCell *cell = [tableView_ dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    //add current controller as delegate to cell's switch control
    cell.delegate = self;

	//if you want to add an image to your cell, here's how
	//UIImage *image = [UIImage imageNamed:@"icon.png"];
	//cell.imageView.image = image;
    
    
	// Configure the cell to show the data.
    NSDictionary *campaignMember;
   
    if(tableView_ == self.tableView) {
        campaignMember = [self.dataRows objectAtIndex: indexPath.row];
    } else {
        campaignMember = [self.filterResults objectAtIndex:indexPath.row];
    }
    NSDictionary *leadOrContact = [campaignMember objectForKey:@"Lead"];
    NSString *type = @"Lead";
    if(leadOrContact == (id)[NSNull null]) {
        type = @"Contact";
        leadOrContact = [campaignMember objectForKey:@"Contact"];
    }
    cell.memberName.text = [leadOrContact objectForKey:@"Name"];
    cell.emailLabel.text = [leadOrContact objectForKey:@"Email"] == [NSNull null] ? @"" : [leadOrContact objectForKey:@"Email"];
    cell.phoneLabel.text = [leadOrContact objectForKey:@"Phone"] == [NSNull null] ? @"" : [leadOrContact objectForKey:@"Phone"];

    NSString *campaignMemberStatus = [campaignMember objectForKey:@"Status"];
    if ([campaignMemberStatus isEqualToString: @"Sent"]) {
           [cell.checkInSwitch setOn:NO animated:NO];
            cell.checkInLabel.text = @"  NO SHOW  ";
    } else {
           [cell.checkInSwitch setOn:YES animated:NO];
              cell.checkInLabel.text = @"CHECKED IN";
    }

	return cell;
}

-(void)amountEntered:(CustomCell *)cell {
    NSIndexPath *indexPath;
    NSDictionary *campaignMember;
    if(self.searchDisplayController.isActive) {
            indexPath = [[self.searchDisplayController searchResultsTableView] indexPathForCell: cell];
            campaignMember = [self.filterResults objectAtIndex:indexPath.row];
    } else {
        indexPath = [self.tableView indexPathForCell: cell];
        campaignMember = [self.dataRows objectAtIndex:indexPath.row];
    }
    NSString *id = [campaignMember objectForKey:@"Id"];
    
 campaignMember = [self.filterResults objectAtIndex:indexPath.row];
    NSString *newStatus;
    if([cell.checkInSwitch isOn]) {
      [cell.checkInSwitch setOn:YES animated:NO];
      cell.checkInLabel.text  = @"CHECKED IN";
      newStatus = @"Responded";
    } else {
        [cell.checkInSwitch setOn:NO animated:NO];
        cell.checkInLabel.text  = @"  NO SHOW  ";
        newStatus = @"Send";
    }
    
    [self updateCheckInStatus:@"CampaignMember" objectId:id newStatus:newStatus];
    
}


- (void)tableView:(UITableView *)itemTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRowIndex = indexPath.row;
}


@end
