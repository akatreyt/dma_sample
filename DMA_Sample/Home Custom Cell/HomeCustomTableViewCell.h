//
//  HomeCustomTableViewCell.h
//  DMA_Sample
//
//  Created by Gary Tartt on 2/2/15.
//  Copyright (c) 2015 Gary Tartt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCustomTableViewCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UIImageView *cellImageView;
@property (nonatomic, retain) IBOutlet UILabel *title;
@property (nonatomic, retain) IBOutlet UILabel *desc;
@end
