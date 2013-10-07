//
//  ConfirmViewController.h
//  ManageSystem
//
//  Created by wjj on 13-10-7.
//  Copyright (c) 2013年 WN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataXMLNode.h"

@interface ConfirmViewController : UIViewController

@property(strong, nonatomic)NSMutableArray *name;
@property(strong, nonatomic)NSMutableArray *count;
@property (weak, nonatomic) IBOutlet UILabel *labelHallName;
@property(strong, nonatomic)NSString *hallName;
@property(strong, nonatomic)NSString *branchId;
@property(strong, nonatomic)NSString *year;
@property(strong, nonatomic)NSString *month;
@property(strong, nonatomic)NSString *day;
@property(strong, nonatomic)NSString *time;

@end