//
//  HomeRowObject.m
//  DMA_Sample
//
//  Created by Gary Tartt on 2/2/15.
//  Copyright (c) 2015 Gary Tartt. All rights reserved.
//

#import "HomeRowObject.h"

@implementation HomeRowObject


/*
 since these are set to read only in the header
 we synntesize so we can write to them
 */
@synthesize title = title_;
@synthesize text = text_;
@synthesize date = date_;
@synthesize link = link_;
@synthesize image_url = image_url_;

-(id)init :(NSDictionary *)data
{
    if ( self = [super init] )
    {
        if([[data allKeys] containsObject:@"title"])
        {
            NSString *title = [data valueForKey:@"title"];
            title_ = title;
        }
        
        if([[data allKeys] containsObject:@"text"])
        {
            NSString *text = [data valueForKey:@"text"];
            text_ = text;
        }
        
        if([[data allKeys] containsObject:@"image"])
        {
            NSString *image_link = [data valueForKey:@"image"];
            image_url_ = [NSURL URLWithString:image_link];
        }
        
        if([[data allKeys] containsObject:@"dates"])
        {
            NSString *date = [data valueForKey:@"dates"];
            date_ = date;
        }
        
        if([[data allKeys] containsObject:@"image_link"])
        {
            NSString *link = [data valueForKey:@"image_link"];
            link_ = link;
        }
    }
    return self;
}
@end
