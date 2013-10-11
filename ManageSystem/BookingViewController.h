//
//  BookingViewController.h
//  ManageSystem
//
//  Created by wjj on 13-10-4.
//  Copyright (c) 2013年 WN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GDataXMLNode.h"
#import "DrawLine.h"
#import "ChooseBookingViewController.h"

@interface BookingViewController : UIViewController
{
    NSMutableArray *bookingData;
    NSMutableArray *pageData;
    NSMutableArray *isHaveRemainCount;
    NSMutableArray *remainCount;
    int thisMonth;
    int thisYear;
}
@property (strong, nonatomic)NSString *branchId;
@property (strong, nonatomic)NSString *tlgId;
@property (strong, nonatomic)NSString *serverTime;
@property (strong, nonatomic)NSString *endTime;
@property (strong, nonatomic)NSString *beginTime;
@property (strong, nonatomic)NSString *monthBeginDay;
@property (strong, nonatomic)IBOutlet UIButton *dateButton;
@property (strong, nonatomic)IBOutlet UILabel *dataLabel;
@property (weak, nonatomic) IBOutlet UILabel *headerLabel;
@property (strong, nonatomic)NSString *headerString;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *lastButton;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic)NSString *selectDay;
@property (strong, nonatomic) IBOutlet UIButton *timeButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *rightButton;
 
- (IBAction)nextMonth:(id)sender;
- (IBAction)lastMonth:(id)sender;

-(void)drawWeakLabel;
-(void)setData;
-(void)drawCalendar;
-(void)setPageData:(int)month : (int)year;
-(void)nextMonth;
-(void)lastMonth;
-(NSString *)judgeStopTime:(NSString*)date;
-(NSString *)judgeBeginTime:(NSString*)date;
-(int)judgeDay:(int)month :(int)year;


@end
