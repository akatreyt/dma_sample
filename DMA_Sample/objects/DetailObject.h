//
//  DetailObject.h
//  DMA_Sample
//
//  Created by Gary Tartt on 2/2/15.
//  Copyright (c) 2015 Gary Tartt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailObject : NSObject
@property (nonatomic, readonly) NSString *summary;
@property (nonatomic, readonly) NSString *photoOneURL;
@property (nonatomic, readonly) NSString *photoTwoURL;
@property (nonatomic, readonly) NSString *title;


-(id)init :(NSDictionary *)data;
@end
