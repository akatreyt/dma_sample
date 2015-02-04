//
//  HomeRowObject.h
//  DMA_Sample
//
//  Created by Gary Tartt on 2/2/15.
//  Copyright (c) 2015 Gary Tartt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailObject.h"

/*
 we add a details object so once we fetch
 we can cache and if the user view this
 details we dont have to fetch again
 */

@interface HomeRowObject : NSObject
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSURL *image_url;
@property (nonatomic, readonly) NSString *text;
@property (nonatomic, readonly) NSString *date;
@property (nonatomic, readonly) NSString *link;
@property (nonatomic, retain) NSData *imageData;
@property (nonatomic, retain) DetailObject *details;

-(id)init :(NSDictionary *)data;
@end
