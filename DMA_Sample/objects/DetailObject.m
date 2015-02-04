//
//  DetailObject.m
//  DMA_Sample
//
//  Created by Gary Tartt on 2/2/15.
//  Copyright (c) 2015 Gary Tartt. All rights reserved.
//

#import "DetailObject.h"

@implementation DetailObject

@synthesize summary = summary_;
@synthesize photoOneURL = photoOneURL_;
@synthesize photoTwoURL = photoTwoURL_;
@synthesize title = title_;

-(id)init :(NSDictionary *)data
{
    if ( self = [super init] )
    {
        if([[data allKeys] containsObject:@"photo_1"])
        {
            NSString *photo_1 = [data valueForKey:@"photo_1"];
            photoOneURL_ = photo_1;
        }
        
        if([[data allKeys] containsObject:@"summary"])
        {
            NSString *summary = [data valueForKey:@"summary"];
            summary_ = summary;
        }
        
        if([[data allKeys] containsObject:@"photo_2"])
        {
            NSString *photo_2 = [data valueForKey:@"photo_2"];
            photoTwoURL_ = photo_2;
        }
        
        if([[data allKeys] containsObject:@"title"])
        {
            NSString *title = [data valueForKey:@"title"];
            title_ = title;
        }
        
    }
    return self;
}


@end
