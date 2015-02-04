//
//  NetworkController.m
//  DMA_Sample
//
//  Created by Gary Tartt on 2/2/15.
//  Copyright (c) 2015 Gary Tartt. All rights reserved.
//

#import "NetworkController.h"
#import "Common.h"
#import "NSString+Hash.h"
#import "DetailObject.h"

@interface NetworkController ()
@property (nonatomic, retain) NSURLSession *session;
@end


@implementation NetworkController

/*
 
 custom init method to setup nsurlsession defaults
 
 */
-(id)init
{
    if ( self = [super init] )
    {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        [sessionConfig setHTTPAdditionalHeaders:@{@"Accept": @"application/json"}];
        sessionConfig.timeoutIntervalForRequest = 30.0;
        sessionConfig.timeoutIntervalForResource = 60.0;
        sessionConfig.HTTPMaximumConnectionsPerHost = 3;
        self.session = [NSURLSession sessionWithConfiguration:sessionConfig
                                                     delegate:self
                                                delegateQueue:nil];
    }
    return self;
}

/*
 
 get the data, converts to objects, returns to caller via callback
 
 */
-(void)getData :(NSString *)urlStr :(GetData)callBack;
{
    NSString *stringWithAPIKey = (dev) ?
    [urlStr stringByReplacingOccurrencesOfString:@"YOUR_API_KEY" withString:devAPIKey] :
    [urlStr stringByReplacingOccurrencesOfString:@"YOUR_API_KEY" withString:prodAPIKey];
    
    NSURL *url = [NSURL URLWithString:stringWithAPIKey];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url
                                                 completionHandler:^( NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          if (error)
                                          {
                                              callBack(false, nil);
                                              return;
                                          }
                                          
                                          NSHTTPURLResponse *httpRespones = (NSHTTPURLResponse *)response;
                                          if (httpRespones.statusCode == 200)
                                          {
                                              NSError *jsonError;
                                              
                                              NSDictionary *allHomeElements = [NSJSONSerialization
                                                                               JSONObjectWithData:data
                                                                               options:NSJSONReadingAllowFragments
                                                                               error:&jsonError];
                                              
                                              if(jsonError)
                                              {
                                                  callBack(false, nil);
                                                  return;
                                              }
                                              
                                              HomeObject *homeObject = [[HomeObject alloc] init:allHomeElements];
                                              
                                              NSMutableArray *convertedElements = [[NSMutableArray alloc] init];
                                              
                                              NSArray *results = [allHomeElements valueForKey:@"results"];
                                              for(NSDictionary *result in results)
                                              {
                                                  HomeRowObject *newOjb = [[HomeRowObject alloc] init:result];
                                                  [convertedElements addObject:newOjb];
                                              }
                                              [homeObject setRowObjects:convertedElements];
                                              callBack(true, homeObject);
                                              return;
                                          }
                                          callBack(false, nil);
                                          return;
                                      }];
    
    [dataTask resume];
}

/*
 
 get the detail data for the home row object
 
 */
-(void)getDetailData :(NSString *)urlStr :(GetDetail)callBack
{
    NSString *completeURL = [NSString stringWithFormat:@"%@", detail_url_str];
    completeURL = [completeURL stringByReplacingOccurrencesOfString:@"WEB_URL" withString:urlStr];
    
    completeURL = (dev) ?
    [completeURL stringByReplacingOccurrencesOfString:@"YOUR_API_KEY" withString:devAPIKey] :
    [completeURL stringByReplacingOccurrencesOfString:@"YOUR_API_KEY" withString:prodAPIKey];
    
    NSURL *url = [NSURL URLWithString:completeURL];
    
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithURL:url
                                                 completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          if (error)
                                          {
                                              callBack(false, nil);
                                              return;
                                          }
                                          
                                          NSHTTPURLResponse *httpRespones = (NSHTTPURLResponse *)response;
                                          if (httpRespones.statusCode == 200)
                                          {
                                              NSError *jsonError;
                                              
                                              NSDictionary *detailData = [NSJSONSerialization
                                                                          JSONObjectWithData:data
                                                                          options:NSJSONReadingAllowFragments
                                                                          error:&jsonError];
                                              
                                              if(jsonError)
                                              {
                                                  callBack(false, nil);
                                                  return;
                                              }
                                              
                                              NSDictionary *results = [detailData valueForKey:@"results"][0];
                                              DetailObject *detailObject = [[DetailObject alloc] init:results];
                                              callBack(true, detailObject);
                                              return;
                                          }
                                          callBack(false, nil);
                                          return;
                                      }];
    
    [dataTask resume];
}

/*
 
 get the image
 
 */
-(void)getImage :(HomeRowObject *)object :(GetImage)callback
{
    NSURL *imageURL = object.image_url;
    
    NSString *md5 = [imageURL.description md5];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:md5];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:getImagePath])
    {
        NSData *imageData = [NSData dataWithContentsOfFile:getImagePath];
        object.imageData = imageData;
        callback(true, object);
        return;
    }
    else
    {
        NSURLSessionDownloadTask *getImageTask =
        [self.session downloadTaskWithURL:imageURL
         
                        completionHandler:^(NSURL *location,
                                            NSURLResponse *response,
                                            NSError *error) {
                            if(error)
                            {
                                callback(false, object);
                                return;
                            }
                            
                            NSData *imageData = [NSData dataWithContentsOfURL: imageURL];
                            [imageData writeToFile:getImagePath atomically:YES];
                            object.imageData = imageData;
                            callback(true, object);
                            return;
                        }];
        
        [getImageTask resume];
    }
}


-(void)getDataImage :(NSString *)urlStr :(GetDataImage)callback
{
    NSURL *imageURL = [NSURL URLWithString:urlStr];
    
    NSString *md5 = [imageURL.description md5];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:md5];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:getImagePath])
    {
        NSData *imageData = [NSData dataWithContentsOfFile:getImagePath];
        callback(true, imageData);
        return;
    }
    else
    {
        NSURLSessionDownloadTask *getImageTask =
        [self.session downloadTaskWithURL:imageURL
         
                        completionHandler:^(NSURL *location,
                                            NSURLResponse *response,
                                            NSError *error) {
                            if(error)
                            {
                                callback(false, nil);
                                return;
                            }
                            
                            NSData *imageData = [NSData dataWithContentsOfURL: imageURL];
                            [imageData writeToFile:getImagePath atomically:YES];
                            callback(true, imageData);
                            return;
                        }];
        
        [getImageTask resume];
    }
}

@end
