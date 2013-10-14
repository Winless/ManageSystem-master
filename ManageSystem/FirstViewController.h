//
//  FirstViewController.h
//  ManageSystem
//
//  Created by WN on 13-9-12.
//  Copyright (c) 2013年 WN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IndexTableCell.h"
#import "DetailViewController.h"
#import "GDataXMLNode.h"
#import "EGORefreshTableHeaderView.h"
#import "MBProgressHUD.h"

@interface FirstViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, EGORefreshTableHeaderDelegate, MBProgressHUDDelegate>
{
//    MBProgressHUD *HUD;
    NSMutableArray *branchName;
    NSMutableArray *branchId;
    NSMutableArray *waitCount;
    NSMutableArray *maxWaitTime;
    NSMutableArray *branchAddr;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}
- (GDataXMLDocument *)parseNetworkXml:(NSString *)urlStr;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
- (void)reloadTableViewDataSource;
- (void)doneLoadingTableViewData;

@end
