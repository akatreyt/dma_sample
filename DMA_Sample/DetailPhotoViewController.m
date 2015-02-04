//
//  DetailPhotoViewController.m
//  DMA_Sample
//
//  Created by Gary Tartt on 2/3/15.
//  Copyright (c) 2015 Gary Tartt. All rights reserved.
//

#import "DetailPhotoViewController.h"

@interface DetailPhotoViewController ()
@property (nonatomic, weak) IBOutlet UIScrollView *photoScrollView;
@property (nonatomic, weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *loading;
@property (nonatomic, assign) BOOL fetching;
@end

@implementation DetailPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
    /*
        get Photos here so we have the width of the scrollview
        only need to call getPhotos once, so we set a bool that stays true
        once we start feching
     */
    if(!self.fetching)
    {
        [self getPhotos];
    }
}

/*
    we know we can only have two images, so this isn't so bad
    if we were to have more then would get refactored to be more flexiable
 */
-(void)getPhotos
{
    self.fetching = true;
    int numberOfPhotos = 0;
    [self.loading setHidden:NO];
    if(self.detailObj.photoOneURL)
    {
        numberOfPhotos += 1;
        
        GetDataImage dataCallBack = ^(BOOL succeed, NSData *imageData)
        {
            if(succeed)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(![self.loading isHidden])
                    {
                        [self.loading setHidden:YES];
                    }
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.photoScrollView.frame.size.width, self.photoScrollView.frame.size.height)];
                    [imageView setContentMode:UIViewContentModeScaleAspectFit];
                    [imageView setImage:[UIImage imageWithData:imageData]];
                    [self.photoScrollView addSubview:imageView];
                });
            }
            else
            {
                
            }
        };
        [self.networkController getDataImage :self.detailObj.photoOneURL :dataCallBack];
    }
    
    if(self.detailObj.photoTwoURL)
    {
        numberOfPhotos += 1;
        
        GetDataImage dataCallBack = ^(BOOL succeed, NSData *imageData)
        {
            if(succeed)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(![self.loading isHidden])
                    {
                        [self.loading setHidden:YES];
                    }
                    CGFloat x = (numberOfPhotos > 1) ? self.photoScrollView.frame.size.width : 0;
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, self.photoScrollView.frame.size.width, self.photoScrollView.frame.size.height)];
                    [imageView setContentMode:UIViewContentModeScaleAspectFit];
                    [imageView setImage:[UIImage imageWithData:imageData]];
                    [self.photoScrollView addSubview:imageView];
                });
            }
            else
            {
                
            }
        };
        [self.networkController getDataImage :self.detailObj.photoTwoURL :dataCallBack];
    }
    
    [self.pageControl setNumberOfPages:numberOfPhotos];
    [self.pageControl setCurrentPage:0];
    [self.photoScrollView setPagingEnabled:YES];
    
    CGFloat scrollViewWidth = 0;
    if(numberOfPhotos > 1)
    {
        scrollViewWidth = self.photoScrollView.frame.size.width * 2;
    }
    else if(numberOfPhotos > 0)
    {
        scrollViewWidth = self.photoScrollView.frame.size.width;
    }
        
    [self.photoScrollView setContentSize:CGSizeMake(scrollViewWidth, self.photoScrollView.frame.size.height)];
}

#pragma mark scroll view delegate
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = self.photoScrollView.frame.size.width;
    int page = floor((self.photoScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.pageControl.currentPage = page;
}


#pragma mark IBAction
-(IBAction)exit:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
