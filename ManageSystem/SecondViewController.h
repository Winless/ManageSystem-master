//
//  SecondViewController.h
//  ManageSystem
//
//  Created by WN on 13-9-12.
//  Copyright (c) 2013年 WN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataXMLNode.h"

@interface SecondViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
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
