//
//  DetailViewController.h
//  ManageSystem
//
//  Created by WN on 13-9-12.
//  Copyright (c) 2013年 WN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailViewTableCell.h"
#import "GDataXMLNode.h"
#import "CorePlot-CocoaTouch.h"
#import "MBProgressHUD.h"
#import "TKAlertCenter.h"	

@interface DetailViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, MBProgressHUDDelegate, CPTPlotDataSource>
{
    MBProgressHUD *HUD;
    NSMutableArray *history;
    NSMutableArray *real;
    NSMutableArray *day;
    NSMutableArray *hour;
    NSMutableArray *waitTime;
    CPTXYGraph *graph;
    NSMutableArray* pointsScrot;
    NSMutableArray* pointsBar1;
    NSMutableArray* pointsBar2;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *toggleControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *centerImg;
@property (weak, nonatomic) IBOutlet UIView *Graph1;
@property (weak, nonatomic) IBOutlet UIView *Graph2;
@property (strong, nonatomic) NSMutableArray *brachIdArr;
@property (nonatomic) NSUInteger brachIdArrId;
@property (strong, nonatomic) NSString *branchId;
@property (strong, nonatomic) NSString *waitCount;
@property (strong, nonatomic) NSString *maxWaitTime;
@property (strong, nonatomic) NSString *avgWaitTime;
@property (strong, nonatomic) NSString *dealingCount;
@property (strong, nonatomic) NSString *finishCount;
@property (strong, nonatomic) NSString *onlineWindowCount;
@property (strong, nonatomic) NSString *imageUrl;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *serverTime;
@property (strong, nonatomic) IBOutlet UITableView *detailTableView;

- (IBAction)toggleControl:(id)sender;
-(CPTGraphHostingView *)drawBar;
-(CPTGraphHostingView *)drawScort;


@end
