//
//  ViewController.m
//  Acronyms
//
//  Created by William Chang on 11/9/15.
//  Copyright © 2015 WillChang. All rights reserved.
//

#import "AcronymTableViewController.h"
#import "AcronymTableViewCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "Acronym.h"

#define	APIURL	@"http://www.nactem.ac.uk/software/acromine/dictionary.py"


@interface AcronymTableViewController ()
@property (nonatomic,strong) NSMutableArray* definitionArray;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation AcronymTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getDefintions:(NSString*)acronymString
{

    NSString *string = [NSString stringWithFormat:@"%@?sf=%@", APIURL,acronymString];
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //MBProgressHUD requirement
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Fetching Results...";
    [hud show:YES];
    
    //AFHTTPRequest requirement, async calls
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
       //Tests resoponse object
        NSLog(@"RESPONSE:%@",[responseObject description]);
        
        //Converts to our NSObject model
        NSArray* acronymModel = [Acronym arrayOfModelsFromDictionaries: responseObject];
        //Add to datasource
        if([acronymModel count]>0){
         self.definitionArray=[((Acronym*)[acronymModel firstObject]).lfs mutableCopy];
        }else{
         [self.definitionArray removeAllObjects];
        }
        [self.tableView reloadData];
        [hud hide:YES];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //show error messsage if no network connection or cannot reach API
        [hud hide:YES];
        MBProgressHUD *hudFail = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hudFail.labelText = @"Error Fetching Results...";
        [hudFail show:YES];
        [hudFail hide:YES afterDelay:3];
    }];
    

    [operation start];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger numOfSections = 0;
    if ([self.definitionArray count]>0)
    {
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        numOfSections                 = 1;
        self.tableView.backgroundView   = nil;
    }
    else
    {
        //show no results when no results or empty data source
        UILabel *noDataLabel         = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
        noDataLabel.text             = @"No results";
        noDataLabel.textColor        = [UIColor blackColor];
        noDataLabel.textAlignment    = NSTextAlignmentCenter;
        self.tableView.backgroundView = noDataLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    
    return numOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.definitionArray count];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    AcronymTableViewCell *cell = (AcronymTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[AcronymTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //Get our definition object
    Definition * definition = [self.definitionArray objectAtIndex:(indexPath.row)];

    cell.textView.text=definition.lf;

    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
   //add details to the meanings if necessary
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //initiate search
     [self getDefintions:searchBar.text];
    //dont show keyboard
     [searchBar resignFirstResponder];
}






@end
