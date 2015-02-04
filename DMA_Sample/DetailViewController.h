//
//  DetailViewController.h
//  DMA_Sample
//
//  Created by Gary Tartt on 2/2/15.
//  Copyright (c) 2015 Gary Tartt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeObject.h"
#import "NetworkController.h"
#import "HomeRowObject.h"

@interface DetailViewController : UIViewController

@property (nonatomic, strong) HomeRowObject *detailObject;
@property (nonatomic, strong) NetworkController *networkController;


-(IBAction)viewDetailPhotos:(id)sender;
@end

