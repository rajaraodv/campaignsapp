//
//  CustomCell.m
//  CampaignsApp
//
//  Created by Raja Rao DV on 2/2/14.
//  Copyright (c) 2014 Sample Apps from Salesforce. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        self.memberName = [[UILabel alloc] initWithFrame:(CGRectMake(20,6,275,30))];
//         self.memberName.font = [UIFont boldSystemFontOfSize:25.0f];
//        [self.contentView addSubview:self.memberName];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)toggleAction:(id)sender {
    
    //Is anyone listening
    if([self.delegate respondsToSelector:@selector(amountEntered:)])
    {
        //send the delegate function with the amount entered by the user
        [self.delegate amountEntered:self];
    }
    
//    
//     NSLog(@"****** %hhd", [self.checkInSwitch isOn]);
//    if([self.checkInSwitch isOn])
//        
//    {
//        
//        [self.checkInSwitch setOn:YES animated:NO];
//        
//        self.checkInLabel.text  = @"CHECKED IN";
//        
//    }
//    
//    else
//        
//    {
//        
//        [self.checkInSwitch setOn:NO animated:NO];
//        
//        self.checkInLabel.text  = @"";
//        
//    }
//    NSLog(@"****** %hhd", [self.checkInSwitch isOn]);
    
}

@end
