//
//  APIClient.m
//  iPUC
//
//  Created by Ozeias Furtozo on 23/04/17.
//  Copyright © 2017 Barbara Santos. All rights reserved.
//

#import "APIClient.h"

@implementation APIClient

NSString * const APIErrorDomain = @"net.someSolucoes.errorDomain";

static NSString * const APIBaseURL = @"http://57f903ad.ngrok.io";

+ (instancetype)sharedClient {
    static APIClient *_sharedClient = nil;
    
    _sharedClient = [[APIClient alloc] initWithBaseURL:[NSURL URLWithString:[self baseUrl]]];
    _sharedClient.requestSerializer = [AFJSONRequestSerializer serializer];
    
    CustomAFJSONResponseSerializer *serializer = [CustomAFJSONResponseSerializer serializer];
    serializer.removesKeysWithNullValues = YES;
    _sharedClient.responseSerializer = serializer;
    
    User *user = [User restoreFromUserDefaults];
    if (user.authorization.length)
        [_sharedClient.requestSerializer setValue:user.authorization forHTTPHeaderField:@"Authorization"];
    return _sharedClient;
}

+ (NSString*)baseUrl{
    return APIBaseURL;
}

+ (NSString *)URLForAction:(NSString *)action{
    NSString *urlForAction = [NSString stringWithFormat:@"%@/%@", [self baseUrl], action];
    return urlForAction;
}

+ (NSDictionary *)getRespondeBodyWithError:(NSError*)error{
    NSDictionary *message;
    if (error) {
        NSData *dataResponseBodyError = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (dataResponseBodyError) {
            NSError *convertError;
            message = [NSJSONSerialization JSONObjectWithData:[error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey] options:kNilOptions error:&convertError];
            if (!convertError) {
                return message;
            }
        }
    }
    return nil;
}

+ (NSInteger)getStatusCodeWithTask:(NSURLSessionDataTask *)task{
    NSInteger statusCode = 0;
    if (task) {
        statusCode = [(NSHTTPURLResponse*)task.response statusCode];
    }
    return statusCode;
}

@end
