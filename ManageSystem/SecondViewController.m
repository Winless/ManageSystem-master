//
//  SecondViewController.m
//  ManageSystem
//
//  Created by WN on 13-9-12.
//  Copyright (c) 2013年 WN. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController()

@end

@implementation SecondViewController
@synthesize usernameTextField;
@synthesize passwordTextField;
@synthesize usernameMessage;
@synthesize passwordMessage;

Boolean jumpFlag;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"登陆界面";
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
        self.tabBarItem.title = @"预约";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}



- (IBAction)signInButton:(id)sender
{
    

    jumpFlag = YES;
    if([usernameTextField.text length] == 0)
    {
        usernameMessage.hidden = NO;
        jumpFlag = NO;
        usernameMessage.text = @"请输入用户名";
    }
    else
    {
        usernameMessage.hidden = YES;
    }
    if([passwordTextField.text length] == 0)
    {
        passwordMessage.hidden = NO;
        jumpFlag = NO;
        passwordMessage.text = @"请输入密码";
    }
    else
    {
        passwordMessage.hidden = YES;
    }
    if(jumpFlag)
    {
        AppointmentTableViewController *appointmentTableViewController = [[AppointmentTableViewController alloc]initWithNibName:@"AppointmentTableViewController" bundle:nil];
        [self.navigationController pushViewController:appointmentTableViewController animated:YES];

  
    }
    
        
}

- (IBAction)backgroundTouch:(id)sender
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
@end
