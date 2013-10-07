//
//  ConfirmViewController.m
//  ManageSystem
//
//  Created by wjj on 13-10-7.
//  Copyright (c) 2013年 WN. All rights reserved.
//

#import "ConfirmViewController.h"

@interface ConfirmViewController ()

@end

@implementation ConfirmViewController

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
    self.title = @"预约成功";
    [self setData];
}

-(void) setData
{
    GDataXMLDocument *doc = [self parseXml:@"http://61.177.61.252/services/CommonSession/getBranchTree?branchId=0"];
    GDataXMLElement *rootElement = [doc rootElement];
    GDataXMLElement *secondElement = [[rootElement elementsForName:@"data"] objectAtIndex:0];
    GDataXMLElement *thirdElement = [[secondElement elementsForName:@"item"] objectAtIndex:0];
    GDataXMLElement *fourElement = [[thirdElement elementsForName:@"item"] objectAtIndex:0];
    self.labelHallName.text = [[fourElement attributeForName:@"branch_name"] stringValue];

    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
