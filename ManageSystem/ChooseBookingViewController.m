//
//  ChooseBooking.m
//  ManageSystem
//
//  Created by wjj on 13-10-7.
//  Copyright (c) 2013年 WN. All rights reserved.
//

#import "ChooseBookingViewController.h"

@interface ChooseBookingViewController ()
{
    ConfirmViewController *confirmController;
}

@end

@implementation ChooseBookingViewController
@synthesize time;
@synthesize year;
@synthesize month;
@synthesize day;
@synthesize branchId;
@synthesize tlgId;
@synthesize rightButton;

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
    [self setData];
    confirmController.name = [NSMutableArray arrayWithCapacity:30];
    confirmController.count = [NSMutableArray arrayWithCapacity:30];
    for (int i = 0; i < 30; i++)
    {
        confirmController.count[i] = @"0";
        tag[i] = 0;
    }
    confirmController = [[ConfirmViewController alloc]init];
    self.title = @"选择预约业务";
    rightButton = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleBordered target:self action:@selector(selectRightAction:)];
    [rightButton setEnabled:NO];
    self.navigationItem.rightBarButtonItem = rightButton;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)selectRightAction:(id)sender
{
    confirmController.branchId = branchId;
    confirmController.year = year;
    confirmController.month = month;
    confirmController.day = day;
    [self.navigationController pushViewController:confirmController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setData
{
    NSString *url = @"http://61.177.61.252/services/CommonSession/getTicketLogicGroupList?branchId=";
    url = [url stringByAppendingString:self.branchId];
    subtypeName = [NSMutableArray arrayWithCapacity:0];
    GDataXMLDocument *doc = [self parseXml:url];
    GDataXMLElement *rootElement = [doc rootElement];
    GDataXMLElement *secondElement = [[rootElement elementsForName:@"data"] objectAtIndex:0];
    GDataXMLElement *thirdElement = [[secondElement elementsForName:@"item"] objectAtIndex:0];
    NSArray *items = [thirdElement elementsForName:@"item"];
    for (GDataXMLElement *item in items)
    {
        [subtypeName addObject:[[item attributeForName:@"subtype_name"]stringValue]];
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
    return [subtypeName count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    Boolean nibsFlag = NO;
    if(!nibsFlag)
    {
        UINib *nib = [UINib nibWithNibName:@"ChooseBookingTableCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsFlag = YES;
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChooseBookingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[ChooseBookingTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell.textField addTarget:self action:@selector(onEditing:) forControlEvents:UIControlEventEditingDidBegin];
    if (indexPath.row == 0)
    {
        cell.label1.text = @"业务名称";
        cell.label2.text = @"数量";
        cell.textField.hidden = YES;
        cell.image.hidden = YES;
        cell.image.image = [UIImage imageNamed:@"disselect.png"];
    }
    else
    {
        for(int i = 1;i <= [subtypeName count];i++)
        {
            cell.label2.text = @"";
            if(indexPath.row == i)
            {
                cell.label1.text = [NSString stringWithFormat:@"%@", [subtypeName objectAtIndex:i - 1]];
                if (tag[indexPath.row] == 0)
                {
                    cell.image.image = [UIImage imageNamed:@"disselect.png"];
                }
                else
                {
                    cell.image.image = [UIImage imageNamed:@"select.png"];
                }
                cell.textField.hidden = YES;
            }
            
        }
    }
    
    return cell;
}

-(void)onEditing:(UITextField*)textField
{
    

    [rightButton setEnabled:YES];
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
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChooseBookingTableCell *cell = (ChooseBookingTableCell*)[self.tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row)
    {
        if(tag[indexPath.row] == 1)
        {
            cell.image.image = [UIImage imageNamed:@"disselect.png"];
            tag[indexPath.row] = 0;
            cell.textField.hidden = YES;
            cell.textField.text = @"";
            confirmController.count[indexPath.row - 1] = @"0";
        }
        else
        {
            cell.image.image = [UIImage imageNamed:@"select.png"];
            cell.textField.hidden = NO;
            tag[indexPath.row] = 1;
            confirmController.name[indexPath.row - 1] = cell.label1;
            confirmController.count[indexPath.row - 1] = cell.label2;
        
        }
        
    }
    
}

@end
