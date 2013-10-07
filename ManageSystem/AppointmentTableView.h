//
//  AppointmentTableView.h
//  ManageSystem
//
//  Created by wjj on 13-10-3.
//  Copyright (c) 2013年 WN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataXMLNode.h"

@interface AppointmentTableView : UITableView
{
    NSMutableArray* address;
    NSMutableArray* name;
}
@property (weak, nonatomic) IBOutlet UITabBarItem *tabBar1;
@property (weak, nonatomic) IBOutlet UITabBarItem *tabBar2;
@property (weak, nonatomic) IBOutlet UITabBarItem *tabBar3;
@property (weak, nonatomic) IBOutlet UITabBarItem *tabBar4;
@property (weak, nonatomic) IBOutlet UITabBarItem *tabBar5;
@property (weak, nonatomic) IBOutlet UITableView *appointmentTableView;

- (GDataXMLDocument *)parseXml:(NSString *)urlStr;
- (void)setData;


@end
