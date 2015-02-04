//
//  DetailViewController.m
//  DMA_Sample
//
//  Created by Gary Tartt on 2/2/15.
//  Copyright (c) 2015 Gary Tartt. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailPhotoViewController.h"


@interface DetailViewController ()
@property (nonatomic, weak) IBOutlet UIImageView *bgImageView;
@property (nonatomic, weak) IBOutlet UITextView *textField;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *dateLabel;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailObject != newDetailItem) {
        _detailObject = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{    
    self.bgImageView.image = [UIImage imageWithData:self.detailObject.imageData];
}

/*
    fetch and load the detail data for an object
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIActivityIndicatorView *loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [loadingSpinner startAnimating];
    self.navigationItem.titleView = loadingSpinner;
    
    UIBarButtonItem *viewPhotos = [[UIBarButtonItem alloc] initWithTitle:@"View Photos"
                                                                   style:UIBarButtonItemStyleDone target:self
                                                                  action:@selector(viewDetailPhotos:)];
    self.navigationItem.rightBarButtonItem = viewPhotos;
    
    [self configureView];
    
    /*
        if detail object has details we dont need to fetch 
        else fetch and store as object's data
     */
    if(self.detailObject.details)
    {
        [self setViewDetails];
        return;
    }

    GetDetail dataCallBack = ^(BOOL succeed, DetailObject *detailObject)
    {
        if(succeed)
        {
            [self.detailObject setDetails:detailObject];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self setViewDetails];
            });
        }
        else
        {
            
        }
    };
    
    [self.networkController getDetailData:self.detailObject.link.description :dataCallBack];
}

-(void)setViewDetails
{
    self.titleLabel.text = self.detailObject.details.title;
    self.dateLabel.text = self.detailObject.date;
    self.textField.text = self.detailObject.details.summary;
    self.navigationItem.titleView = nil;
    self.title = @"";
}

-(IBAction)viewDetailPhotos:(id)sender
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    DetailPhotoViewController * vc = (DetailPhotoViewController *)[sb instantiateViewControllerWithIdentifier:@"DetailPhotoViewController"];
    [vc setDetailObj:self.detailObject.details];
    [vc setNetworkController:self.networkController];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
