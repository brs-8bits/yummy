//
//  Custom.m
//  iPUC
//
//  Created by Ozeias Furtozo on 23/04/17.
//  Copyright © 2017 Barbara Santos. All rights reserved.
//

#import "CustomAFJSONResponseSerializer.h"

@implementation CustomAFJSONResponseSerializer

const NSString *kAuthorizationToken = @"Authorization";

- (id)responseObjectForResponse:(NSURLResponse *)response data:(NSData *)data error:(NSError *__autoreleasing *)error{
    [self renewAuthorizationTokenForResponse:response];
    id serialized = [super responseObjectForResponse:response data:data error:error];
    return serialized;
}

- (void)renewAuthorizationTokenForResponse:(NSURLResponse *)response {

    NSDictionary* headers = [(NSHTTPURLResponse *)response allHeaderFields];
    if (headers) {
        NSMutableString *authorizationToken = [headers objectForKey:kAuthorizationToken];
        
        if (authorizationToken.length) {
            [[APIClient sharedClient].requestSerializer setValue:authorizationToken
                                              forHTTPHeaderField:@"Authorization"];
        }
    }
    
}

@end
