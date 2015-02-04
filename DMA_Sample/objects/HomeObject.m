//
//  HomeObject.m
//  DMA_Sample
//
//  Created by Gary Tartt on 2/2/15.
//  Copyright (c) 2015 Gary Tartt. All rights reserved.
//

#import "HomeObject.h"

#define kDefaultTitle @"Current Exhibitions"

@implementation HomeObject
@synthesize title = title_;

/*
    if there is a title key set the title
    if not set it to kDefaultTitle
 */
-(id)init :(NSDictionary *)data
{
    if ( self = [super init] )
    {
        if([[data allKeys] containsObject:@"title"])
        {
            NSString *title = [data valueForKey:@"title"];
            title_ = title;
        }
        else
        {
            title_ = kDefaultTitle;
        }
    }
    return self;
}

@end

