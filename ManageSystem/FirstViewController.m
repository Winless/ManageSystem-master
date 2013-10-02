//
//  FirstViewController.m
//  ManageSystem
//
//  Created by WN on 13-9-12.
//  Copyright (c) 2013年 WN. All rights reserved.
//


#import "FirstViewController.h"
//test


@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if (_refreshHeaderView == nil)
    {
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
		view.delegate = self;
		[self.tableView addSubview:view];
		_refreshHeaderView = view;
        
	}
    [_refreshHeaderView refreshLastUpdatedDate];
    
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title = @"返回";
    self.navigationItem.backBarButtonItem = backbutton;
    
    branchName = [NSMutableArray arrayWithCapacity:0];
    branchId = [NSMutableArray arrayWithCapacity:0];
    branchAddr = [NSMutableArray arrayWithCapacity:0];
    waitCount = [NSMutableArray arrayWithCapacity:0];
    maxWaitTime = [NSMutableArray arrayWithCapacity:0];
    
    [self setTableViewData];
}

- (void)setTableViewData
{
    GDataXMLDocument *doc = [self parseNetworkXml:@"http://61.177.61.252/services/MobileSession/getBranchSimpleInfo?branchId=0"];
    GDataXMLElement *rootElement = [doc rootElement];
    GDataXMLElement *secondElement = [[rootElement elementsForName:@"data"] objectAtIndex:0];
    GDataXMLElement *thirdElement = [[secondElement elementsForName:@"item"] objectAtIndex:0];
    [branchName addObject:[[thirdElement attributeForName:@"branch_name"] stringValue]];
    [branchId addObject:[[thirdElement attributeForName:@"branch_id"] stringValue]];
    [waitCount addObject:[[thirdElement attributeForName:@"wait_count"] stringValue]];
    [maxWaitTime addObject:[[thirdElement attributeForName:@"max_wait_time"] stringValue]];
    NSArray *items = [thirdElement elementsForName:@"item"];
    NSLog(@"%@", items);
    for (GDataXMLElement *item in items)
    {
        [branchName addObject:[[item attributeForName:@"branch_name"] stringValue]];
        [branchId addObject:[[item attributeForName:@"branch_id"] stringValue]];
        [waitCount addObject:[[item attributeForName:@"wait_count"] stringValue]];
        [maxWaitTime addObject:[[item attributeForName:@"max_wait_time"] stringValue]];
    }
    NSLog(@"%@", branchName);
    
    doc = [self parseNetworkXml:@"http://61.177.61.252/services/CommonSession/getBranchTree?branchId=0"];
    rootElement = [doc rootElement];
    secondElement = [[rootElement elementsForName:@"data"] objectAtIndex:0];
    thirdElement = [[secondElement elementsForName:@"item"] objectAtIndex:0];
    [branchAddr addObject:[[thirdElement attributeForName:@"branch_addr"] stringValue]];
    items = [thirdElement elementsForName:@"item"];
    for (GDataXMLElement *item in items)
    {
        [branchAddr addObject:[[item attributeForName:@"branch_addr"] stringValue]];
    }
}

- (GDataXMLDocument *)parseNetworkXml:(NSString *)urlStr
{
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest* request = [NSMutableURLRequest new];
    [request setURL:url];
    [request setHTTPMethod:@"GET"];
    NSHTTPURLResponse* response;
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    NSString* responseXMLResult = [[NSString alloc] initWithData:data encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
    NSString *newXMLStr = [responseXMLResult stringByReplacingOccurrencesOfString:@"encoding=\"GBK\"" withString:@"encoding=\"UTF-8\""];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:newXMLStr options:0 error:&error];
    return doc;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"苏州市办税服务厅概况";
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        self.tabBarItem.title = @"查询";
    }
    return self;
}

#pragma tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        return branchName.count-1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableIdentifier = @"tableIdentfier";
    
    static BOOL nibsRegistered = NO;
    if (!nibsRegistered)
    {
        UINib *nib = [UINib nibWithNibName:@"IndexTableCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:tableIdentifier];
        nibsRegistered = YES;
    }
    
    IndexTableCell *cell = [tableView dequeueReusableCellWithIdentifier:tableIdentifier];
    
    if (indexPath.section == 0)
    {
        cell.name.text = [NSString stringWithFormat:@"%@",[branchName objectAtIndex:0]];
        cell.waitingPeople.text = [NSString stringWithFormat:@"%@",[waitCount objectAtIndex:0]];
        cell.address.text = [NSString stringWithFormat:@"%@",[branchAddr objectAtIndex:0]];
        cell.minutes.text = [NSString stringWithFormat:@"%@",[maxWaitTime objectAtIndex:0]];
    }
    else
    {
        for (int i = 1; i < branchName.count; i++)
        {
            if (indexPath.row == i-1)
            {
                cell.name.text = [NSString stringWithFormat:@"%@",[branchName objectAtIndex:i]];
                cell.waitingPeople.text = [NSString stringWithFormat:@"%@",[waitCount objectAtIndex:i]];
                cell.address.text = [NSString stringWithFormat:@"%@",[branchAddr objectAtIndex:i]];
                cell.minutes.text = [NSString stringWithFormat:@"%@",[maxWaitTime objectAtIndex:i]];
            }
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailViewController *detailViewController;
    if (detailViewController == nil)
    {
        detailViewController = [[DetailViewController alloc] init];
    }
    if (indexPath.section == 0)
    {
        detailViewController.branchId = @"0";
    }
    else
    {
    detailViewController.branchId = [NSString stringWithFormat:@"%@", [branchId objectAtIndex:indexPath.row+1]];
    }
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark -
#pragma mark Data Source Loading / Reloading Methods

- (void)reloadTableViewDataSource
{
	//  should be calling your tableviews data source model to reload
	//  put here just for demo
    
	_reloading = YES;
}

- (void)doneLoadingTableViewData
{
	//  model should call this when its done loading
    
    [branchName removeAllObjects];
    [branchId removeAllObjects];
    [branchAddr removeAllObjects];
    [maxWaitTime removeAllObjects];
    [waitCount removeAllObjects];
    [self setTableViewData];
	[self.tableView reloadData];
    
	_reloading = NO;
	[_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
	
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
}


#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
	
	[self reloadTableViewDataSource];
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:2.0];
	
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    
	return _reloading; // should return if data source model is reloading
	
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
	
	return [NSDate date]; // should return date data source was last changed
	
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
