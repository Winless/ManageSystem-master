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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"选择大厅";
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
        
    }
    return self;
}

-(void)setData
{
    
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
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    address = [NSMutableArray arrayWithCapacity:0];
    name = [NSMutableArray arrayWithCapacity:0];
    [self setData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
