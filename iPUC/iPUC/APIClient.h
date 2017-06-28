//
//  APIClient.h
//  iPUC
//
//  Created by Ozeias Furtozo on 23/04/17.
//  Copyright © 2017 Barbara Santos. All rights reserved.
//

#import "AFHTTPSessionManager.h"

//MODELS
#import "User.h"

//TOOLS
#import "CustomAFJSONResponseSerializer.h"
#import "Block.h"

@interface APIClient : AFHTTPSessionManager

extern NSString * const APIErrorDomain;

+ (instancetype)sharedClient;
+ (NSString*)URLForAction:(NSString*)action;

+ (NSInteger)getStatusCodeWithTask:(NSURLSessionDataTask*)task;
+ (NSDictionary*)getRespondeBodyWithError:(NSError*)error;

+ (NSString*)baseUrl;

@end
