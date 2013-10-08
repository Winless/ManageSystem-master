//
//  ChooseBooking.h
//  ManageSystem
//
//  Created by wjj on 13-10-7.
//  Copyright (c) 2013年 WN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataXMLNode.h"
#import "ChooseBookingTableCell.h"
#import "ConfirmViewController.h"

@interface ChooseBookingViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *subtypeName;
    int tag[30];
}

@property (strong, nonatomic)NSString *time;
@property (strong, nonatomic)NSString *year;
@property (strong, nonatomic)NSString *month;
@property (strong, nonatomic)NSString *day;
@property (strong, nonatomic)NSString *tlgId;
@property (strong, nonatomic)NSString *branchId;
@property (strong, nonatomic)IBOutlet UIBarButtonItem *rightButton;

- (IBAction)backgroundTouch:(id)sender;
-(void)setData;

@end
