//
//  MasterViewController.m
//  DMA_Sample
//
//  Created by Gary Tartt on 2/2/15.
//  Copyright (c) 2015 Gary Tartt. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "NetworkController.h"
#import "Common.h"
#import "HomeObject.h"
#import "HomeCustomTableViewCell.h"
#import "HomeRowObject.h"

@interface MasterViewController ()
@property (nonatomic, retain) NetworkController *networkController;
@property (nonatomic, retain) HomeObject *homeObject;
@property (nonatomic, retain) UIRefreshControl *refreshControl;

@property (nonatomic, weak) IBOutlet UIView *errorView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

    
    _refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(tapToReload:) forControlEvents:UIControlEventValueChanged];
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;
    tableViewController.refreshControl = self.refreshControl;

    
    [self getHomeData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
    fetch all the home data
 */
-(void)getHomeData
{
    if(!self.networkController)
    {
        _networkController = [[NetworkController alloc] init];
    }
   
    [self.errorView setHidden:YES];
    
    GetData homeDataCallback = ^(BOOL succeed, HomeObject *homeObject)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(succeed)
            {
                self.homeObject = homeObject;
                self.title = self.homeObject.title;
                [self.tableView reloadData];
                
                [self.tableView setHidden:NO];
                [self.errorView setHidden:YES];
            }
            else
            {
                [self.tableView setHidden:YES];
                [self.errorView setHidden:NO];
            }
            [self.refreshControl endRefreshing];
        });
    };
    
    [self.errorView setHidden:YES];
    
    [self.refreshControl beginRefreshing];
    
    if (self.tableView.contentOffset.y == 0) {
        
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^(void){
            
            self.tableView.contentOffset = CGPointMake(0, -self.refreshControl.frame.size.height);
            
        } completion:^(BOOL finished){
            
        }];
        
    }
    
    [self.networkController getData:home_url_str :homeDataCallback];
}


/*
 fetch the image for a HomeRowObject
 */
-(void)getImageForObject :(HomeRowObject *)object
{
    if(!self.networkController)
    {
        _networkController = [[NetworkController alloc] init];
    }
    
    GetImage objectImageCallback = ^(BOOL succeed, HomeRowObject *homeObject)
    {
        if(succeed)
        {
           dispatch_async(dispatch_get_main_queue(), ^{
               int idx = (int)[self.homeObject.rowObjects indexOfObject:homeObject];
               [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:idx inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
           });
        }
        else
        {
            
        }
    };
    
    [self.networkController getImage:object :objectImageCallback];
}


#pragma mark IBAction
-(IBAction)tapToReload:(id)sender
{
    NSArray *iterateArray = [self.homeObject.rowObjects copy];
    
    for(HomeRowObject *obj in iterateArray)
    {
        NSIndexPath *path = [NSIndexPath indexPathForRow:[self.homeObject.rowObjects indexOfObject:obj] inSection:0];
        [self.homeObject.rowObjects removeObject:obj];
        [self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationLeft];
    }

    /*
        
     we delay the call 1 second to allow the animation to finish
     
     */
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getHomeData];
    });
    
    
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        HomeRowObject *object = self.homeObject.rowObjects[indexPath.row];
        DetailViewController *controller = (DetailViewController *)[segue destinationViewController];
        [controller setDetailObject:object];
        [controller setNetworkController:self.networkController];
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.homeObject.rowObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeCustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeCell" forIndexPath:indexPath];

    HomeRowObject *object = self.homeObject.rowObjects[indexPath.row];
    cell.title.text = [object title];
    cell.desc.text = [object text];
    
    if(object.imageData)
    {
        UIImage *image = [UIImage imageWithData:object.imageData];
        cell.cellImageView.image = image;
    }
    else
    {
        [self getImageForObject:object];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self.homeObject.rowObjects removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
}
@end
