//
//  DetailViewController.m
//  ManageSystem
//
//  Created by WN on 13-9-12.
//  Copyright (c) 2013年 WN. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize Graph1;
@synthesize Graph2;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"加载中...";
    HUD.minSize = CGSizeMake(135.f, 135.f);
    [HUD showWhileExecuting:@selector(getData) onTarget:self withObject:nil animated:YES];
}

-(void)getData
{
    NSString *urlStr = @"http://61.177.61.252/services/MobileSession/getBranchRealtimeInfo?branchId=";
    urlStr = [urlStr stringByAppendingString:self.branchId];
    GDataXMLDocument *doc = [self parseNetworkXml:urlStr];
    GDataXMLElement *rootElement = [doc rootElement];
    GDataXMLElement *serverTimeElement = [[rootElement elementsForName:@"server_time"] objectAtIndex:0];
    GDataXMLElement *secondElement = [[rootElement elementsForName:@"data"] objectAtIndex:0];
    GDataXMLElement *thirdElement = [[secondElement elementsForName:@"item"] objectAtIndex:0];
    self.serverTime.text = [serverTimeElement stringValue];
    self.title = [[thirdElement attributeForName:@"branch_name"] stringValue];
    self.waitCount = [[thirdElement attributeForName:@"wait_count"] stringValue];
    self.maxWaitTime = [[thirdElement attributeForName:@"max_wait_time"] stringValue];
    self.avgWaitTime = [[thirdElement attributeForName:@"avg_wait_time"] stringValue];
    self.dealingCount = [[thirdElement attributeForName:@"dealing_count"] stringValue];
    self.finishCount = [[thirdElement attributeForName:@"finish_count"] stringValue];
    self.onlineWindowCount = [[thirdElement attributeForName:@"online_window_count"] stringValue];
    self.imageUrl = [[thirdElement attributeForName:@"image_url"] stringValue];
    
    NSData *data=[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://61.177.61.252/%@", self.imageUrl]]];
    UIImage *img=[UIImage imageWithData:data];
    self.centerImg.image = img;
    
    
    history = [NSMutableArray arrayWithCapacity:0];
    real = [NSMutableArray arrayWithCapacity:0];
    day = [NSMutableArray arrayWithCapacity:0];
    hour = [NSMutableArray arrayWithCapacity:0];
    waitTime = [NSMutableArray arrayWithCapacity:0];
    pointsBar1 = [NSMutableArray arrayWithCapacity:0];
    pointsBar2 = [NSMutableArray arrayWithCapacity:0];
    pointsScrot = [NSMutableArray arrayWithCapacity:0];
    
    NSString *urlStr2 = @"http://61.177.61.252/services/MobileSession/getHistoryWaitTimeByDay?branchId=";
    urlStr2 = [urlStr2 stringByAppendingString:self.branchId];
    doc = [self parseNetworkXml:urlStr2];
    rootElement = [doc rootElement];
    secondElement = [[rootElement elementsForName:@"data"] objectAtIndex:0];
    NSArray *items = [secondElement elementsForName:@"item"];
    for (GDataXMLElement *item in items)
    {
        [history addObject:[[item attributeForName:@"history_wait_time"] stringValue]];
        [real addObject:[[item attributeForName:@"real_wait_time"] stringValue]];
        [day addObject:[[item attributeForName:@"day"] stringValue]];
    }
    
    NSString *urlStr3 = @"http://61.177.61.252/services/MobileSession/getTodayWaitCountDistribution?branchId=";
    urlStr3 = [urlStr3 stringByAppendingString:self.branchId];
    doc = [self parseNetworkXml:urlStr3];
    rootElement = [doc rootElement];
    secondElement = [[rootElement elementsForName:@"data"] objectAtIndex:0];
    items = [secondElement elementsForName:@"item"];
    for (GDataXMLElement *item in items)
    {
        [hour addObject:[[item attributeForName:@"hour"] stringValue]];
        [waitTime addObject:[[item attributeForName:@"wait_count"] stringValue]];
    }
    [self drawBar];
    [self drawScort];
    
    [self performSelectorOnMainThread:@selector(reloadTableViewData) withObject:nil waitUntilDone:YES];
    
    
    
    
}
-(CPTGraphHostingView *)drawBar
{
    [super viewDidLoad];
    graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    
    graph.paddingLeft = 0;
    //顶部的的padding设置0
	graph.paddingTop = 0;
    //右边的padding设置为0
	graph.paddingRight = 0;
    //底部的padding设置为0
	graph.paddingBottom = 0;
    
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    
    [graph applyTheme:theme];
    
    CPTGraphHostingView *hostingView = (CPTGraphHostingView*)Graph1;
    
    hostingView.hostedGraph = graph;
    graph.title = @"本月图表:等候时间(分)";
    graph.titleDisplacement = CGPointMake(-70, 0);
    
    CPTXYPlotSpace *plotSpace =(CPTXYPlotSpace *)graph.defaultPlotSpace;
    
    pointsBar1 = [[NSMutableArray alloc]init];
    pointsBar2 = [[NSMutableArray alloc]init];
    
    int month = 7, j;
    
    if(month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12)
        j = 31;
    else if(month == 4 || month == 6 || month == 9 || month == 11)
        j = 30;
    else
        j = 28;
    
    NSUInteger i;
    int maxWaitTime = 0, separate;
    
    for ( i = 0; i < j; i++)
    {
        int a = [[history objectAtIndex:i]intValue];
        if(a > maxWaitTime)
            maxWaitTime = a;
        a = [[real objectAtIndex:i]intValue];
        if(a > maxWaitTime)
            maxWaitTime = a;
    }
    
    separate = maxWaitTime / 5;
    for ( i = 0; i < j; i++ ) {
        
        int a = [[history objectAtIndex:i]intValue];
        id x = [NSNumber numberWithFloat:0.013 + i * 0.03];
        
        id y = [NSNumber numberWithFloat:a * 0.09 / (separate + 1)];
        
        [pointsBar1 addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x",y, @"y", nil]];
        
        a = [[real objectAtIndex:i]intValue];
        x = [NSNumber numberWithFloat:0.022 + i * 0.03];
        y = [NSNumber numberWithFloat:a * 0.09 / (separate + 1)];
        [pointsBar2 addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x",y, @"y", nil]];
    }
    
    plotSpace.allowsUserInteraction=NO;
    
    plotSpace.globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.16)length:CPTDecimalFromFloat(0.8)];
    
    plotSpace.globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1)length:CPTDecimalFromFloat(1.95)];
    
    
    CPTXYAxisSet*axisSet = (CPTXYAxisSet *)graph.axisSet;
    
    CPTXYAxis*x   = axisSet.xAxis;
    
    
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    
    x.majorIntervalLength=CPTDecimalFromString(@"0.5");
    x.orthogonalCoordinateDecimal= CPTDecimalFromString(@"0");
    
    
    
    NSMutableArray *labelArray=[NSMutableArray arrayWithCapacity:j];
    
    CPTMutableTextStyle *labelX;
    
    labelX = [[CPTMutableTextStyle alloc]init];
    labelX.color = [CPTColor blackColor];
    labelX.fontSize = 7.0f;
    
    CPTAxisLabel *newLabel ;
    x.labelOffset -= 10;
    
    for(int i = 1;i <= j;i++)
    {
        if(i < 10)
            newLabel=[[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"0%d", i] textStyle:labelX];
        else
            newLabel=[[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%d", i] textStyle:labelX];
        
        newLabel.tickLocation = CPTDecimalFromFloat (-0.013 + i * 0.03);
        newLabel.offset = x.labelOffset + x.majorTickLength ;
        [labelArray addObject :newLabel];
    }
    
    x.axisLabels=[NSSet setWithArray:labelArray];
    
    axisSet.xAxis.visibleAxisRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromString(@"0") length:CPTDecimalFromString(@"10")];
    
    axisSet.yAxis.visibleAxisRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromString(@"0") length:CPTDecimalFromString(@"10")];
    
    CPTXYAxis*y   = axisSet.yAxis;
    
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    
    
    
    labelArray=[NSMutableArray arrayWithCapacity:7];
    
    CPTMutableTextStyle *labelY;
    
    NSMutableArray *locationArray=[NSMutableArray arrayWithCapacity:7];
    
    labelY = [[CPTMutableTextStyle alloc]init];
    labelY.color = [CPTColor blackColor];
    labelY.fontSize = 8.0f;
    
    y.labelOffset -= 10;
    
    for(int i = 0;i < 6;i++)
    {
        newLabel=[[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%d", i * (maxWaitTime / 5 + 1)] textStyle:labelY];
        
        newLabel.tickLocation = CPTDecimalFromFloat (0 + i * 0.09);
        [locationArray addObject:[NSNumber numberWithFloat:0 + i * 0.09 ]];
        newLabel.offset = y.labelOffset + y.majorTickLength ;
        [labelArray addObject :newLabel];
    }
    y.axisLabels=[NSSet setWithArray:labelArray];
    
    CPTPlotRange*range=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromString(@"0")
                                                    length:CPTDecimalFromString(@"5")];
    y.gridLinesRange=range;
    y.majorTickLocations = [NSSet setWithArray:locationArray];
    
    CPTBarPlot*boundBarHistoryPlot  = [[CPTBarPlot alloc] init];
    CPTBarPlot *boundBarRealPlot = [[CPTBarPlot alloc]init];
    
    boundBarHistoryPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor greenColor] horizontalBars:NO];
    
    boundBarHistoryPlot.barWidth = CPTDecimalFromFloat(0.007f);
    boundBarHistoryPlot.identifier = @"BarHistory";
    boundBarHistoryPlot.labelOffset = 5;
    
    boundBarHistoryPlot.dataSource = self;
    [graph addPlot:boundBarHistoryPlot];
    
    
    boundBarRealPlot = [[CPTBarPlot alloc] init];
    
    boundBarRealPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor grayColor] horizontalBars:NO];
    boundBarRealPlot.barWidth = CPTDecimalFromFloat(0.007f);
    boundBarRealPlot.identifier = @"BarReal";
    boundBarRealPlot.dataSource = self;
    boundBarRealPlot.labelOffset = 0.3f;
    
    [graph addPlot:boundBarRealPlot];
    
    
    return hostingView;
}

-(CPTGraphHostingView *)drawScort
{
    // Do any additional setup after loading the view, typically from a nib.
    graph = [[CPTXYGraph alloc] initWithFrame:CGRectZero];
    
    graph.paddingLeft = 0;
    //顶部的的padding设置0
	graph.paddingTop = 0;
    //右边的padding设置为0
	graph.paddingRight = 0;
    //底部的padding设置为0
	graph.paddingBottom = 0;
    
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    graph.title = @"当日大厅等候人数";
    graph.titleDisplacement = CGPointMake(-70, 0);
    [graph applyTheme:theme];
    
    CPTGraphHostingView *hostingView = (CPTGraphHostingView*)Graph2;
    hostingView.hostedGraph = graph;
    
    CPTXYPlotSpace *plotSpace =(CPTXYPlotSpace *)graph.defaultPlotSpace;
    
    pointsScrot=[[NSMutableArray alloc]init];
    
    NSUInteger i;
    int maxWaitTime = 0;
    int separate;
    for ( i = 0; i < [hour count]; i++)
    {
        
        int a = [[waitTime objectAtIndex:i]intValue];
        
        if(a > maxWaitTime)
            maxWaitTime = a;
    }

    separate = maxWaitTime / 50;
    for ( i = 0; i < [hour count]; i++)
    {
        
        int a = [[waitTime objectAtIndex:i]intValue];
        
        id x = [NSNumber numberWithFloat:0.02 + i * 0.09];
        
        id y = [NSNumber numberWithFloat:a * 0.009 / (separate + 1)];
        
        [pointsScrot addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:x, @"x",y, @"y", nil]];
    }
    
    plotSpace.allowsUserInteraction=YES;
    
    plotSpace.globalYRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.16)length:CPTDecimalFromFloat(0.8)];
    
    plotSpace.globalXRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-1)length:CPTDecimalFromFloat(1.95)];
    CPTScatterPlot*boundLinePlot  = [[CPTScatterPlot alloc] init];
    
    CPTMutableLineStyle*lineStyle = [CPTMutableLineStyle lineStyle];
    
    lineStyle.miterLimit = 1.0f;
    
    lineStyle.lineWidth = 1.0f;
    
    lineStyle.lineColor = [CPTColor blackColor];
    
    boundLinePlot.dataLineStyle= lineStyle;
    
    boundLinePlot.identifier = @"Blue Plot";
    
    boundLinePlot.dataSource = self;
    
    [graph addPlot:boundLinePlot];
    
    CPTXYAxisSet*axisSet = (CPTXYAxisSet *)graph.axisSet;
    

    CPTXYAxis*x   = axisSet.xAxis;
    
    
    x.labelingPolicy = CPTAxisLabelingPolicyNone;
    
    x.majorIntervalLength=CPTDecimalFromString(@"0.5");
    x.orthogonalCoordinateDecimal= CPTDecimalFromString(@"0");
    
    NSMutableArray *labelArray=[NSMutableArray arrayWithCapacity:11];
    
    CPTMutableTextStyle *labelX;
    
    labelX = [[CPTMutableTextStyle alloc]init];
    labelX.color = [CPTColor blackColor];
    labelX.fontSize = 7.0f;
    
    CPTAxisLabel *newLabel ;
    x.labelOffset -= 10;
    
    for(int i = 0;i < 11;i++)
    {
        newLabel=[[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%d:00", i + 8] textStyle:labelX];
        
        newLabel.tickLocation = CPTDecimalFromFloat (0.02 + i * 0.09);
        newLabel.offset = x.labelOffset + x.majorTickLength ;
        [labelArray addObject :newLabel];
    }
    
    x.axisLabels=[NSSet setWithArray:labelArray];
    
    axisSet.xAxis.visibleAxisRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromString(@"0") length:CPTDecimalFromString(@"10")];
    
    axisSet.yAxis.visibleAxisRange=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromString(@"0") length:CPTDecimalFromString(@"10")];
    
    CPTXYAxis*y   = axisSet.yAxis;
    
    
    y.labelingPolicy = CPTAxisLabelingPolicyNone;
    y.majorGridLineStyle = lineStyle;
    
    
    labelArray=[NSMutableArray arrayWithCapacity:7];
    
    CPTMutableTextStyle *labelY;
    
    NSMutableArray *locationArray=[NSMutableArray arrayWithCapacity:7];
    
    labelY = [[CPTMutableTextStyle alloc]init];
    labelY.color = [CPTColor blackColor];
    labelY.fontSize = 8.0f;
    
    y.labelOffset -= 10;
    
    for(int i = 0;i < 6;i++)
    {
        newLabel=[[CPTAxisLabel alloc] initWithText:[NSString stringWithFormat:@"%d", i * (maxWaitTime / 50 * 10 + 10)] textStyle:labelY];
        
        newLabel.tickLocation = CPTDecimalFromFloat (0 + i * 0.09);
        //        locationArray.addObject:[NSNumber number (0.03 + i * 0.12)];
        [locationArray addObject:[NSNumber numberWithFloat:0 + i * 0.09 ]];
        newLabel.offset = y.labelOffset + y.majorTickLength ;
        [labelArray addObject :newLabel];
    }
    y.axisLabels=[NSSet setWithArray:labelArray];
    CPTPlotRange*range=[CPTPlotRange plotRangeWithLocation:CPTDecimalFromString(@"0")
                                                    length:CPTDecimalFromString(@"5")];
    y.gridLinesRange=range;
    y.majorTickLocations = [NSSet setWithArray:locationArray];
    //    y.title = @"当前大厅等候人数";
    return hostingView;
}

-(void)reloadTableViewData
{
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
	HUD.mode = MBProgressHUDModeCustomView;
	HUD.labelText = @"加载成功!";
    [self.tableView reloadData];
}

#pragma tableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //建立可重用单元标识
    static NSString *customCell = @"customCell";
    DetailViewTableCell *cell = (DetailViewTableCell *)[tableView dequeueReusableCellWithIdentifier:customCell];
    
    if (cell == nil) {
        //如果没有可重用的单元，我们就从nib里面加载一个，
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"DetailViewTableCell"
                                                     owner:self options:nil];
        //迭代nib重的所有对象来查找NewCell类的一个实例
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass:[DetailViewTableCell class]]) {
                cell = (DetailViewTableCell *)oneObject;
            }
        }
    }

    switch (indexPath.row)
    {
        case 0:
            cell.label1.text = @"大厅概况";
            cell.label2.text = cell.label3.text = cell.label4.text = cell.label5.text = cell.label6.text = @"";
            break;
        case 1:
            cell.label1.text = @"当前等候";
            cell.label2.text = self.waitCount;
            cell.label3.text = @"人";
            cell.label4.text = @"办理中";
            cell.label5.text = self.dealingCount;
            cell.label6.text = @"人";
            break;
        case 2:
            cell.label1.text = @"办结";
            cell.label2.text = self.finishCount;
            cell.label3.text = @"人";
            cell.label4.text = @"在线窗口";
            cell.label5.text = self.onlineWindowCount;
            cell.label6.text = @"个";
            break;
        case 3:
            cell.label1.text = @"最长等候";
            cell.label2.text = self.maxWaitTime;
            cell.label3.text = @"分钟";
            cell.label4.text = @"平均等候";
            cell.label5.text = self.avgWaitTime;
            cell.label6.text = @"分钟";
            break;
        default:
            break;
    }
    
    return cell;
}



#pragma UIScrollView
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.scrollView.contentOffset.x == 0)
    {
        self.toggleControl.selectedSegmentIndex = 0;
    }
    else if (self.scrollView.contentOffset.x == 320)
    {
        self.toggleControl.selectedSegmentIndex = 1;
    }
    else if (self.scrollView.contentOffset.x == 640)
    {
        self.toggleControl.selectedSegmentIndex = 2;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
   // self.leftImg.hidden = NO;
    self.centerImg.hidden = NO;
    //self.rightImg.hidden = NO;
    [self.scrollView setContentSize:CGSizeMake(960,0)];
    [self.scrollView setContentOffset:CGPointMake(320, 0) animated:NO];
    self.toggleControl.selectedSegmentIndex = 1;
}

- (void)viewDidDisappear:(BOOL)animated
{
    //self.leftImg.hidden = YES;
    self.centerImg.hidden = YES;
   // self.rightImg.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)toggleControl:(id)sender
{
    if ([sender selectedSegmentIndex] == 0)
    {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if ([sender selectedSegmentIndex] == 1)
    {
        [self.scrollView setContentOffset:CGPointMake(320, 0) animated:YES];
    }
    else
    {
        [self.scrollView setContentOffset:CGPointMake(640, 0) animated:YES];
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

-(NSNumber*)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index

{
    
    if ( [plot isKindOfClass:[CPTBarPlot class]] )
    {
        
        if([plot.identifier isEqual:@"BarHistory"])
        {
            if(fieldEnum == CPTBarPlotFieldBarLocation)
            {
                NSString*key = @"x";
                NSNumber*num = [[pointsBar1 objectAtIndex:index] valueForKey:key];
                return num;
            }
            else
            {
                NSString*key = @"y";
                NSNumber*num = [[pointsBar1 objectAtIndex:index] valueForKey:key];
                return num;
            }
        }
        else
        {
            if(fieldEnum == CPTBarPlotFieldBarLocation)
            {
                NSString*key = @"x";
                NSNumber*num = [[pointsBar2 objectAtIndex:index] valueForKey:key];
                return num;
            }
            else
            {
                NSString*key = @"y";
                NSNumber*num = [[pointsBar2 objectAtIndex:index] valueForKey:key];
                return num;
            }
        }
    }
    else
    {
        NSString*key = (fieldEnum == CPTScatterPlotFieldX ? @"x" : @"y");
        NSNumber* num = [[pointsScrot objectAtIndex:index] valueForKey:key];
        return num;
        
    }
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot*)plot

{
    if ( [plot isKindOfClass:[CPTBarPlot class]] ) {
        return [pointsBar1 count];
    }
    else
    {
        return[pointsScrot count];
    }
    
    
}


//-(CPTLayer*)dataLabelForPlot:(CPTPlot *)plot recordIndex:( NSUInteger )index
//{
//    // 定义一个白色的 TextStyle
//    CPTMutableTextStyle *numStyle = [[CPTMutableTextStyle alloc]init];
//    
//    
//    // 定义一个 TextLayer
//    CPTTextLayer *numLayer = nil ;
//    NSString * identifier=( NSString *)[plot identifier];
//    if ([identifier isEqualToString : @"BarHistory" ]) {
//        numStyle.color = [ CPTColor greenColor ];
//        numStyle.fontSize = 8.0f;
//        int a = [[history objectAtIndex:index]intValue];
//        if(a)
//            numLayer = [[ CPTTextLayer alloc ] initWithText :[ NSString stringWithFormat : @"%d" , a] style :numStyle];
//        
//        
//    }
//    else if([identifier isEqualToString:@"BarReal"])
//    {
//        numStyle.color = [CPTColor grayColor];
//        numStyle.fontSize = 8.0f;
//        int a = [[real objectAtIndex:index]intValue];
//        if(a)
//            numLayer = [[ CPTTextLayer alloc ] initWithText :[ NSString stringWithFormat : @"%d" , a] style :numStyle];
//        
//    }
//    return numLayer;
//}


@end


























