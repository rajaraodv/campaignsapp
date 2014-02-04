/*
 Copyright (c) 2011, salesforce.com, inc. All rights reserved.
 
 Redistribution and use of this software in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 * Redistributions of source code must retain the above copyright notice, this list of conditions
 and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice, this list of
 conditions and the following disclaimer in the documentation and/or other materials provided
 with the distribution.
 * Neither the name of salesforce.com, inc. nor the names of its contributors may be used to
 endorse or promote products derived from this software without specific prior written
 permission of salesforce.com, inc.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
 FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR
 CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY
 WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */


#import "CampaignsViewController.h"

#import "SFRestAPI.h"
#import "SFRestRequest.h"
//#import "DetailViewController.h"
#import "CampaignMembersViewController.h"

@implementation CampaignsViewController


#pragma mark - filter data

- (void)filterCampaignResults {
    self.filterResults = nil;

    NSPredicate *resultsPredicate = [NSPredicate predicateWithFormat: @"SELF['Name'] contains[c] %@", self.filterField.text];
    self.filterResults = [[self.dataRows filteredArrayUsingPredicate:resultsPredicate] mutableCopy];
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterCampaignResults];
}

#pragma mark Misc

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    self.dataRows = nil;
}


#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hack_checkin_bg.png"]];
//    imageView.alpha = 0.2;
//    self.tableView.backgroundView = imageView;
//    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hack_checkin_bg.png"]];
//    imageView2.alpha = 0.2;
//    [self.searchDisplayController searchResultsTableView].backgroundView = imageView2;

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   // alert = [[UIAlertView alloc] initWithTitle: @"Loading..." message: nil delegate:self cancelButtonTitle: nil otherButtonTitles: nil];

  
   // [alert show];
    // Here we use a query that should work on either Force.com or Database.com.
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForQuery:@"SELECT Id, Name,Status FROM Campaign"];
    [[SFRestAPI sharedInstance] send:request delegate:self];
}

- (void)updateStatus:(NSString *)objectType
                    objectId:(NSString *)objectId
                    quantity:(NSString *)quantity
                       price:(NSString *)price
{
    NSDictionary *fields = [NSDictionary dictionaryWithObjectsAndKeys:
                            quantity, @"Quantity__c",
                            price, @"Price__c",
                            nil];
    SFRestRequest *request = [[SFRestAPI sharedInstance] requestForUpdateWithObjectType:objectType
                                                                               objectId:objectId
                                                                                 fields:fields];
    [[SFRestAPI sharedInstance] send:request delegate:self];
}

#pragma mark - SFRestAPIDelegate

- (void)request:(SFRestRequest *)request didLoadResponse:(id)jsonResponse {
    [alert dismissWithClickedButtonIndex:0 animated:YES];
    NSMutableArray *records = [jsonResponse objectForKey:@"records"];
    NSLog(@"request:didLoadResponse: #records: %d", records.count);
    self.dataRows = records;
    
    
    [self.tableView reloadData];
    [alert dismissWithClickedButtonIndex:0 animated:YES];
}


- (void)request:(SFRestRequest*)request didFailLoadWithError:(NSError*)error {
    [alert dismissWithClickedButtonIndex:0 animated:YES];

    NSLog(@"request:didFailLoadWithError: %@", error);
    //add your failed error handling here
}

- (void)requestDidCancelLoad:(SFRestRequest *)request {
    NSLog(@"requestDidCancelLoad: %@", request);
    //add your failed error handling here
}

- (void)requestDidTimeout:(SFRestRequest *)request {
    [alert dismissWithClickedButtonIndex:0 animated:YES];

    NSLog(@"requestDidTimeout: %@", request);
    //add your failed error handling here
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tblView numberOfRowsInSection:(NSInteger)section {
    
    if(tblView == self.tableView) {
        return [self.dataRows count];
    } else {
        [self filterCampaignResults];
        return [self.filterResults count];
    }
}

//used to change cell's fonts and background colors etc
- (void) tableView:(UITableView *)tblview willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //change color and fonts..
    //cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //cell.textLabel.numberOfLines = 0;
    //cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
    //cell.textLabel.textColor = [UIColor whiteColor];
    //cell.backgroundColor = [UIColor clearColor];
    //cell.backgroundView.backgroundColor = [UIColor clearColor];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView_ cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   static NSString *CellIdentifier = @"CellIdentifier";

   // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView_ dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
	//if you want to add an image to your cell, here's how
	//UIImage *image = [UIImage imageNamed:@"icon.png"];
	//cell.imageView.image = image;
    

    
	// Configure the cell to show the data.
    NSDictionary *obj;
    if(tableView_ == self.tableView) {
         obj = [self.dataRows objectAtIndex:indexPath.row];
    } else {
        obj = [self.filterResults objectAtIndex:indexPath.row];
    }
    cell.textLabel.text =  [obj objectForKey:@"Name"];

	//this adds the arrow to the right hand side.
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

	return cell;

}

- (void)tableView:(UITableView *)itemTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.searchDisplayController.isActive) {
        [self performSegueWithIdentifier:@"ShowCampaignMembersSegue" sender:self];
    }
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"ShowCampaignMembersSegue"]) {
        NSIndexPath *indexPath;
        NSDictionary *obj;
        if(self.searchDisplayController.isActive) {
            indexPath = [[self.searchDisplayController searchResultsTableView] indexPathForSelectedRow];
            obj = [self.filterResults objectAtIndex:indexPath.row];
        } else {
            indexPath = [self.tableView indexPathForSelectedRow];
             obj = [self.dataRows objectAtIndex:indexPath.row];
        }
        
        [[segue destinationViewController] setCampaignObject:obj];
    }
}

@end
