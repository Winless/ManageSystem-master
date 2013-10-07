//
//  ServiceViewController.h
//  ManageSystem
//
//  Created by wjj on 13-10-4.
//  Copyright (c) 2013年 WN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataXMLNode.h"
#import "BookingViewController.h"

@interface ServiceViewController : UITableViewController<UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *serviceListArray;
    NSMutableArray *tlgIdArray;
}

@property(strong, nonatomic)NSString *branchId;

-(void)setData;
@end
