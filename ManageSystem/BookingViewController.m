//
//  BookingViewController.m
//  ManageSystem
//
//  Created by wjj on 13-10-4.
//  Copyright (c) 2013年 WN. All rights reserved.
//

#import "BookingViewController.h"

@interface BookingViewController ()
{
    ChooseBookingViewController *chooseBookingViewController;
}

@end

@implementation BookingViewController
@synthesize branchId;
@synthesize tlgId;
@synthesize serverTime;
@synthesize endTime;
@synthesize beginTime;
@synthesize monthBeginDay;
@synthesize dateButton;
@synthesize dataLabel;
@synthesize headerLabel;
@synthesize headerString;
@synthesize nextButton;
@synthesize lastButton;
@synthesize timeLabel;
@synthesize selectDay;
@synthesize timeButton;
@synthesize rightButton;
Boolean setFlag;

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
    chooseBookingViewController = [[ChooseBookingViewController alloc]init];
    DrawLine *lineView = [[DrawLine alloc] initWithFrame:CGRectMake(0, pointZero, 320, 400)];
    lineView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:lineView];
    self.title = @"选择日期";
    rightButton = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(selectRightAction:)];
    [rightButton setEnabled:NO];
    self.navigationItem.rightBarButtonItem = rightButton;
    pageData = [NSMutableArray arrayWithCapacity:0];
    setFlag  = false;
  //  [self.view bringSubviewToFront:timeLabel];
    [self drawWeakLabel];
    [self setData];
    [self drawCalendar];
    
    
}

-(void)selectRightAction:(id)sender
{
    chooseBookingViewController.year = [NSString stringWithFormat:@"%d",thisYear];
    chooseBookingViewController.month = [NSString stringWithFormat:@"%d",thisMonth];
    chooseBookingViewController.day = selectDay;
    chooseBookingViewController.branchId =branchId;
    chooseBookingViewController.tlgId = tlgId;
    [self.navigationController pushViewController:chooseBookingViewController animated:YES];
}

-(void)drawCalendar
{
  //  [self.view bringSubviewToFront:headerImage];
//    NSLog(@"%d", [bookingData count]);
    int k = 0, x = 0;
    for (int i = 0; i < 5; i++)
    {
        for (int j = 0; j < 7; j++)
        {
            dateButton = [[UIButton alloc]init];
            [dateButton setFrame:CGRectMake(46 * j-1, 60+27*i , 44, 24.5)];
            [dateButton setTitle:[pageData objectAtIndex:k] forState:UIControlStateNormal];
            [dateButton setTitleShadowColor:[UIColor greenColor] forState:UIControlStateNormal ];
            [dateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [dateButton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:dateButton];
            if ([[isHaveRemainCount objectAtIndex:k] isEqual:@"0"])
            {
                [dateButton setEnabled:NO];
                dateButton.titleLabel.textColor = [UIColor grayColor];
            }
            else
            {
                while ([[bookingData objectAtIndex:x]isEqual:@"0"])
                {
                    x++;
                }
                dataLabel = [[UILabel alloc]init];
                dataLabel.backgroundColor=[UIColor clearColor];
                int data =[[bookingData objectAtIndex:x] intValue];
                [dataLabel setFrame:CGRectMake(46 * j + 29, 75 + 27 * i, 14, 10)];
                dataLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:8];
                dataLabel.text = [NSString stringWithFormat:@"%d",data];
                x++;
                [self.view addSubview:dataLabel];
            }
            k++;
            [dateButton setTag:1];
            [dataLabel setTag:1];
        }
    }
    headerString = @"";
    headerString = [headerString stringByAppendingFormat:@"%d", thisYear];
    headerString = [headerString stringByAppendingString:@"年"];
    headerString = [headerString stringByAppendingFormat:@"%d", thisMonth];
    headerString = [headerString stringByAppendingString:@"月"];
    headerLabel.text = headerString;
    headerLabel.backgroundColor = [UIColor grayColor];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"next.png"] forState:UIControlStateNormal];
    [lastButton setBackgroundImage:[UIImage imageNamed:@"last.png"] forState:UIControlStateNormal];
    [nextButton setEnabled:YES];
    [lastButton setEnabled:YES];
    [self.view addSubview:nextButton];
    [self.view addSubview:lastButton];
    if (thisYear == 2013 && thisMonth <= 7)
    {
        [lastButton setEnabled:NO];
    }
    else
    {
        [lastButton setEnabled:YES];
    }

}

-(void)selectButton:(UIButton *)button
{
    NSArray *subviews = [self.view subviews];
    for(UIView *view in subviews)
    {
        if([view isKindOfClass:[UIButton class]] && view.tag == 1)
        {
            [view setBackgroundColor:[UIColor clearColor]];
        }
    }
    [button setBackgroundColor:[UIColor grayColor]];
    remainCount = [NSMutableArray arrayWithCapacity:0];
    self.selectDay = button.titleLabel.text;
    NSString *url = @"http://61.177.61.252/services/BookingSupportSession/getBookingTimeRemain?branchId=";
    url = [url stringByAppendingString:branchId];
    url = [url stringByAppendingString:@"&idtypeId="];
    url = [url stringByAppendingString:tlgId];//&calDate=2013-10-9
    url = [url stringByAppendingString:@"&calDate="];
    url = [url stringByAppendingFormat:@"%d", thisYear];
    url = [url stringByAppendingString:@"-"];
    url = [url stringByAppendingFormat:@"%d", thisMonth];
    url = [url stringByAppendingString:@"-"];
    url = [url stringByAppendingString:selectDay];
    GDataXMLDocument *doc = [self parseXml:url];
    GDataXMLElement *rootElement = [doc rootElement];
    GDataXMLElement *secondElement = [[rootElement elementsForName:@"data"] objectAtIndex:0];
    NSArray *thirdElement = [secondElement elementsForName:@"item"];
    for (GDataXMLElement *item in thirdElement)
    {
        [remainCount addObject:[[item attributeForName:@"remain_count"]stringValue]];
    }
    for(UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UIButton class]] && view.tag > 1)
            [view removeFromSuperview];
    }
    for (int i = 0; i < 14; i++)
    {
        timeButton = [[UIButton alloc]init];
        if (i < 7)
        {
            [timeButton setFrame:CGRectMake(50 + 35.5 * i, 267, 35, 22)];
        }
        else
        {
            [timeButton setFrame:CGRectMake(50 + 35.5 * (i - 7), 326, 35, 22)];
        }
        
        [timeButton setTitle:[remainCount objectAtIndex:i] forState:UIControlStateNormal];
        [timeButton setTitleShadowColor:[UIColor greenColor] forState:UIControlStateNormal ];
        [timeButton setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
        [timeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [timeButton addTarget:self action:@selector(selectTimeButton:) forControlEvents:UIControlEventTouchUpInside];
       // [timeButton setTag:2];
        if ([timeButton.titleLabel.text isEqualToString:@"0"])
        {
            [timeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [timeButton setEnabled:NO];
        }
        [timeButton setTag:i + 2];
        [self.view addSubview:timeButton];
        [self.view bringSubviewToFront:timeButton];
        
    }
    
}

-(void)selectTimeButton:(UIButton *)button
{
    NSArray *subviews = [self.view subviews];
    for(UIView *view in subviews)
    {
        if([view isKindOfClass:[UIButton class]] && view.tag > 1)
        {
            [view setBackgroundColor:[UIColor clearColor]];
            [self.view bringSubviewToFront:view];
        }
    }
    switch (button.tag - 2)
    {
        case 0:
            chooseBookingViewController.time = @"08:30-09:00";
            break;
        case 1:
            chooseBookingViewController.time = @"09:00-09:30";
            break;
        case 2:
            chooseBookingViewController.time = @"09:30-10:00";
            break;
        case 3:
            chooseBookingViewController.time = @"10:00-10:30";
            break;
        case 4:
            chooseBookingViewController.time = @"10:30-11:00";
            break;
        case 5:
            chooseBookingViewController.time = @"11:30-12:00";
            break;
        case 6:
            chooseBookingViewController.time = @"14:00-14:30";
            break;
        case 7:
            chooseBookingViewController.time = @"14:30-15:00";
            break;
        case 8:
            chooseBookingViewController.time = @"15:00-15:30";
            break;
        case 9:
            chooseBookingViewController.time = @"15:30-16:00";
            break;
        case 10:
            chooseBookingViewController.time = @"16:00-16:30";
            break;
        case 11:
            chooseBookingViewController.time = @"16:30-17:00";
            break;
        case 12:
            chooseBookingViewController.time = @"17:00-17:30";
            break;
        default:
            chooseBookingViewController.time = @"17:30-18:00";
            break;
    }
    [button setBackgroundColor:[UIColor grayColor]];
    [rightButton setEnabled:YES];
}

-(void)setPageData:(int)month :(int)year
{
    int lastMonth, begin, day;
    lastMonth = month - 1;
    if (lastMonth == 0)
    {
        lastMonth = 12;
        year--;
    }
    if ([pageData count] != 0)
    {
        [pageData removeAllObjects];
    }
    day = [self judgeDay:lastMonth :year];
    begin = day - [self.monthBeginDay intValue] + 1;
    for (int i = begin; i <= day; i++)
    {
        [pageData addObject:[NSString stringWithFormat:@"%d", i]];
        [isHaveRemainCount addObject:[NSString stringWithFormat:@"%d", 0]];
    }
    day = [self judgeDay:month :year];
    for (int i = 1; i <= day; i++)
    {
        [pageData addObject:[NSString stringWithFormat:@"%d", i]];
        if ([[bookingData objectAtIndex:i - 1]isEqual:@"0"])
        {
            [isHaveRemainCount addObject:[NSString stringWithFormat:@"%d", 0]];
        }
        else
        {
            [isHaveRemainCount addObject:[NSString stringWithFormat:@"%d", 1]];
        }
    }
    NSLog(@"%d", [pageData count]);
    int data = [pageData count];
    for (int i = 1; i <= 35 - data; i++)
    {
        [pageData addObject:[NSString stringWithFormat:@"%d", i ]];
        [isHaveRemainCount addObject:[NSString stringWithFormat:@"%d", 0]];
    }
    
}

- (IBAction)nextMonth:(id)sender
{
    {
        thisMonth++;
        if (thisMonth > 12)
        {
            thisMonth= 1;
            thisYear++;
        }
        NSLog(@"month:%d", thisMonth);
        for(UIView *view in self.view.subviews)
        {
            if ([view isKindOfClass:[UIButton class]] && view.tag == 1)
                [view removeFromSuperview];
            if ([view isKindOfClass:[UILabel class]] && view.tag == 1)
            {
                [view removeFromSuperview];
            }
        }
        [self setData];
        [self drawCalendar];
        [self drawWeakLabel];
    }

}

- (IBAction)lastMonth:(id)sender
{
    thisMonth--;
    if (thisMonth < 1)
    {
        thisMonth = 12;
        thisYear--;
    }
    NSLog(@"month:%d", thisMonth);
    for(UIView *view in self.view.subviews)
    {
        if ([view isKindOfClass:[UIButton class]] && view.tag == 1)
            [view removeFromSuperview];
        if ([view isKindOfClass:[UILabel class]] && view.tag == 1)
        {
            [view removeFromSuperview];
        }
    }
    [self setData];
    [self drawCalendar];
    [self drawWeakLabel];
}

-(void)drawWeakLabel
{
    for (int i = 0; i < 7; i++)
    {
        UILabel *weekLabel = [[UILabel alloc]init];
        [weekLabel setFrame:CGRectMake(46 * i + 15, 40, 20, 15)];
        weekLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:12];
        switch (i)
        {
            case 0:
                weekLabel.text = @"一";
                break;
            case 1:
                weekLabel.text = @"二";
                break;
            case 2:
                weekLabel.text = @"三";
                break;
            case 3:
                weekLabel.text = @"四";
                break;
            case 4:
                weekLabel.text = @"五";
                break;
            case 5:
                weekLabel.text = @"六";
                break;
            default:
                weekLabel.text = @"日";
                break;
        }
        [self.view addSubview:weekLabel];
    }
}

-(void)setData
{
    NSString *url = @"http://61.177.61.252/services/BookingSupportSession/getBookingDayRemain?branchId=";
    url = [url stringByAppendingString:branchId];
    url = [url stringByAppendingString:@"&idtypeId="];
    url = [url stringByAppendingString:tlgId];
    GDataXMLDocument *doc = [self parseXml:url];
    GDataXMLElement *rootElement = [doc rootElement];
    if (!setFlag)
    {
        GDataXMLElement *serverTimeElement = [[rootElement elementsForName:@"server_time"] objectAtIndex:0];
        self.serverTime = [serverTimeElement stringValue];
        self.serverTime = [serverTime substringWithRange:NSMakeRange(0, 10)];
        self.endTime = [self judgeStopTime:serverTime];
        self.beginTime = [self judgeBeginTime:serverTime];
        thisYear = [[serverTime substringWithRange:NSMakeRange(0, 4)]intValue];
        thisMonth = [[serverTime substringWithRange:NSMakeRange(5, 2)]intValue];
        setFlag = true;
    }
    else
    {
        NSString* timeString = [NSString stringWithFormat:@"%d", thisYear];
        timeString = [timeString stringByAppendingString:@"-"];
        timeString = [timeString stringByAppendingString:[NSString stringWithFormat:@"%d", thisMonth]];
        timeString = [timeString stringByAppendingString:@"-"];
        self.beginTime =  [timeString stringByAppendingString:@"01"];
        self.endTime = [timeString stringByAppendingString:[NSString stringWithFormat:@"%d", [self judgeDay:thisMonth :thisYear]]];
    }
    NSLog(@"%@", branchId);
    url = [url stringByAppendingString:@"&startTime="];
    url = [url stringByAppendingString:beginTime];
    url = [url stringByAppendingString:@"%2000:00:00&stopTime="];
    url = [url stringByAppendingString:endTime];
    url = [url stringByAppendingString:@"%2000:00:00"];
    NSLog(@"%@", url);
    bookingData = [NSMutableArray arrayWithCapacity:0];
    isHaveRemainCount = [NSMutableArray arrayWithCapacity:0];
    doc = [self parseXml:url];
    rootElement = [doc rootElement];
    GDataXMLElement *secondElement = [[rootElement elementsForName:@"data"] objectAtIndex:0];
    GDataXMLElement *monthBeginDayElement = [[secondElement elementsForName:@"item"]objectAtIndex:0];
    self.monthBeginDay = [[monthBeginDayElement attributeForName:@"day_of_week"]stringValue];
    NSArray *thirdElement = [secondElement elementsForName:@"item"];
    for (GDataXMLElement *item in thirdElement)
    {
        [bookingData addObject:[[item attributeForName:@"remain_count"]stringValue]];
    }
    
    [self setPageData:thisMonth :thisYear];
    

}

- (GDataXMLDocument *)parseXml:(NSString *)urlStr
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

-(NSString *)judgeStopTime:(NSString *)date
{
    int year, month, day;
    year = [[date substringWithRange:NSMakeRange(0, 4)]intValue];
    month = [[date substringWithRange:NSMakeRange(5, 2)]intValue];
    date = [date substringWithRange:NSMakeRange(0, 8)];
    day = [self judgeDay:month :year];
    date = [date stringByAppendingString:[NSString stringWithFormat:@"%d", day]];
    return date;
}

-(NSString *)judgeBeginTime:(NSString *)date
{
    date = [date substringWithRange:NSMakeRange(0, 8)];
    date = [date stringByAppendingString:@"01"];
    return date;
}

-(int)judgeDay:(int)month :(int)year
{
    int day;
    if (month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12)
    {
        day = 31;
    }
    else if(month == 4 || month == 6 || month == 9 || month == 11)
    {
        day = 30;
    }
    else if(month == 2 && (((year % 4 == 0) && (year % 100 != 0)) || (year % 400 == 0)))
    {
        day = 29;
    }
    else
    {
        day = 28;
    }
    return day;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
