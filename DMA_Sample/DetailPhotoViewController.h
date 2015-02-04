//
//  DetailPhotoViewController.h
//  DMA_Sample
//
//  Created by Gary Tartt on 2/3/15.
//  Copyright (c) 2015 Gary Tartt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailObject.h"
#import "NetworkController.h"


@interface DetailPhotoViewController : UIViewController <UIScrollViewDelegate>

@property (nonatomic, strong) NetworkController *networkController;
@property (nonatomic, strong) DetailObject *detailObj;
-(IBAction)exit:(id)sender;
@end
