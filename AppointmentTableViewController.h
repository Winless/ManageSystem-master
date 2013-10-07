//
//  AppointmentTableViewController.h
//  ManageSystem
//
//  Created by wjj on 13-10-3.
//  Copyright (c) 2013年 WN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppointmentViewTableCell.h"
#import "GDataXMLNode.h"
#import "ServiceViewController.h"

@interface AppointmentTableViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *hallAddress;
    NSMutableArray *hallName;
    NSMutableArray *hallId;
}

@end
