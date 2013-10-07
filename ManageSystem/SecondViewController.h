//
//  SecondViewController.h
//  ManageSystem
//
//  Created by WN on 13-9-12.
//  Copyright (c) 2013年 WN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataXMLNode.h"
#import "AppointmentTableViewController.h"


@interface SecondViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;


@property (weak, nonatomic) IBOutlet UILabel *usernameMessage;
@property (weak, nonatomic) IBOutlet UILabel *passwordMessage;
- (IBAction)signInButton:(id)sender;
- (IBAction)backgroundTouch:(id)sender;


@end
