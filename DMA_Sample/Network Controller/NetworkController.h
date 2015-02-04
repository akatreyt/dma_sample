//
//  NetworkController.h
//  DMA_Sample
//
//  Created by Gary Tartt on 2/2/15.
//  Copyright (c) 2015 Gary Tartt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HomeObject.h"
#import "DetailObject.h"
#import "HomeRowObject.h"

typedef void (^GetData) (BOOL succeed, HomeObject *homeObject);
typedef void (^GetImage) (BOOL succeed, HomeRowObject *homeObject);
typedef void (^GetDataImage) (BOOL succeed, NSData *data);
typedef void (^GetDetail) (BOOL succeed, DetailObject *detailObject);

@interface NetworkController : NSObject <NSURLSessionDataDelegate>


/* get initial data */
-(void)getData :(NSString *)urlStr :(GetData)callBack;

/* get image  */
-(void)getImage :(HomeRowObject *)object :(GetImage)callback;

/* get detail data for row object */
-(void)getDetailData :(NSString *)urlStr :(GetDetail)callBack;

/* get image data from url, no object */
-(void)getDataImage :(NSString *)urlStr :(GetDataImage)callback;

@end
