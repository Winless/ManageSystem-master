//
//  AppointmentTableViewController.m
//  ManageSystem
//
//  Created by wjj on 13-10-3.
//  Copyright (c) 2013年 WN. All rights reserved.
//

#import "AppointmentTableViewController.h"

@interface AppointmentTableViewController ()

@end

@implementation AppointmentTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    hallName = [NSMutableArray arrayWithCapacity:0];
    hallAddress = [NSMutableArray arrayWithCapacity:0];
    hallId = [NSMutableArray arrayWithCapacity:0];
    self.title = @"选择大厅";
    UIBarButtonItem *backbutton = [[UIBarButtonItem alloc]init];
    backbutton.title = @"上一步";
    self.navigationItem.backBarButtonItem = backbutton;
    [self setData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setData
{
    GDataXMLDocument *doc = [self parseXml:@"http://61.177.61.252/services/CommonSession/getBranchTree?branchId=0"];
    GDataXMLElement *rootElement = [doc rootElement];
    GDataXMLElement *secondElement = [[rootElement elementsForName:@"data"] objectAtIndex:0];
    GDataXMLElement *thirdElement = [[secondElement elementsForName:@"item"] objectAtIndex:0];
    NSArray *items = [thirdElement elementsForName:@"item"];
    for (GDataXMLElement *item in items)
    {
        [hallId addObject:[[item attributeForName:@"branch_id"] stringValue]];
        [hallName addObject:[[item attributeForName:@"branch_name"] stringValue]];
        [hallAddress addObject:[[item attributeForName:@"branch_addr"] stringValue]];
    } 
   
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [hallName count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    Boolean nibsFlag = NO;
    if(!nibsFlag)
    {
        UINib *nib = [UINib nibWithNibName:@"AppointmentViewTableCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsFlag = YES;

    }
    
    AppointmentViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[AppointmentViewTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.tag = [indexPath row];
    UIButton *button =[UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(270, 10, 29, 29)];
    [button setBackgroundImage:[UIImage imageNamed:@"jump.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(selectHall:) forControlEvents:UIControlEventTouchUpInside];
    [cell.contentView addSubview:button];
    NSArray *subviews = [cell.contentView subviews];
    for(id view in subviews)
    {
        if([view isKindOfClass:[UIButton class]])
        {
            [view setTag:[indexPath row]];
            [cell.contentView bringSubviewToFront:view];
        }
    }
    
    for(int i = 0;i < [hallName count];i++)
    {
        if(indexPath.row == i)
        {
            cell.nameLabel.text = [NSString stringWithFormat:@"%@", [hallName objectAtIndex:i]];
            cell.addressLabel.text = [NSString stringWithFormat:@"地址:%@", [hallAddress objectAtIndex:i]];
        }
        
    }
    
    return cell;

}

-(void)selectHall:(UIButton *)button
{
    NSArray *visiblecells = [self.tableView visibleCells];
    ServiceViewController *serviceViewConroller = [[ServiceViewController alloc]initWithNibName:@"ServiceViewController" bundle:nil];
    
    for(AppointmentViewTableCell *cell in visiblecells)
    {
        if(cell.tag == button.tag)
        {
            serviceViewConroller.branchId = [NSString stringWithFormat:@"%@", [hallId objectAtIndex:[cell tag]]];
            break;
        }
    }
    
    [self.navigationController pushViewController:serviceViewConroller animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}

@end
