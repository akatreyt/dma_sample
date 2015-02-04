//
//  HomeObject.h
//  DMA_Sample
//
//  Created by Gary Tartt on 2/2/15.
//  Copyright (c) 2015 Gary Tartt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DetailObject.h"


@interface HomeObject : NSObject
@property (nonatomic, readonly) NSString *title;


/*
 mutable so we can slide to delete
 if action is unwanted can to chagne nsarray
 */
@property (nonatomic, retain) NSMutableArray *rowObjects;

-(id)init :(NSDictionary *)data;
@end

