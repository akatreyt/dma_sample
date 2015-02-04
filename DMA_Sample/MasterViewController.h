//
//  MasterViewController.h
//  DMA_Sample
//
//  Created by Gary Tartt on 2/2/15.
//  Copyright (c) 2015 Gary Tartt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MasterViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) DetailViewController *detailViewController;
-(IBAction)tapToReload:(id)sender;
@end

