//
//  UserBusiness.m
//  iPUC
//
//  Created by Ozeias Furtozo on 23/04/17.
//  Copyright © 2017 Barbara Santos. All rights reserved.
//

#import "UserBusiness.h"

@implementation UserBusiness

+(void)signinUser:(User*)user
      withSuccess:(successBlockWithResponseObject)successBlock
           orFail:(errorBlockWithErrorObject)errorBlock{
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary
                                       dictionaryWithDictionary:
                                       @{@"password"    : user.password ?: @"",
                                         @"email"       : user.email    ?: @""}];
//MOCK
//    user.name = @"TES";
//    user.ID = 5454;
//    user.created_at = [NSDate new];
//    user.updated_at = [NSDate new];
//    
//    user.authorization = @"askjldfklhsdjhfjhafsdjhldf";
//    [user storeInUserDefaults];
//    
//    if (successBlock) successBlock(user);
    
    [[super sharedClient] POST:@"singin" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        User *userResponse = [[User alloc] initWithDictionary:responseObject];
        
        //NSHTTPURLResponse *header   = (NSHTTPURLResponse *)task.response;
        userResponse.authorization  = responseObject[@"authorization"];//[header.allHeaderFields objectForKey:@"Authorization"];
    
        [userResponse storeInUserDefaults];
        
        if (successBlock) successBlock(userResponse);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (errorBlock) errorBlock(error);
    }];
    
}

+(void)logoutUser:(User*)user
       withSucess:(successBlockWithResponseObject)successBlock{
    
    [user removeFromUserDefaults];
    if (successBlock) successBlock(nil);
    NSLog(@"BARBARA");
    
}

+(void)signupUser:(User*)user
      withSuccess:(successBlockWithResponseObject)successBlock
           orFail:(errorBlockWithErrorObject)errorBlock{
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary
                                       dictionaryWithDictionary:
                                       @{@"name"        : user.name     ?: @"",
                                         @"password"    : user.password ?: @"",
                                         @"email"       : user.email    ?: @"",
                                         @"photo"       : [UIImagePNGRepresentation(user.photo?: [[UIImage alloc] init]) base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength] ?: @""}];
    //MOCK
    //    user.name = @"TES";
    //    user.ID = 5454;
    //    user.created_at = [NSDate new];
    //    user.updated_at = [NSDate new];
    //
    //    user.authorization = @"askjldfklhsdjhfjhafsdjhldf";
    //    [user storeInUserDefaults];
    //
    //    if (successBlock) successBlock(user);
    
    [[super sharedClient] POST:@"singup" parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"%@", uploadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        User *userResponse = [[User alloc] initWithDictionary:responseObject];
        
        //NSHTTPURLResponse *header   = (NSHTTPURLResponse *)task.response;
        userResponse.authorization  = responseObject[@"authorization"];//[header.allHeaderFields objectForKey:@"Authorization"];
        
        [userResponse storeInUserDefaults];
        
        if (successBlock) successBlock(userResponse);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (errorBlock) errorBlock(error);
    }];
    
}

+(void)putUser:(User *)user withSuccess:(successBlockWithResponseObject)successBlock orFail:(errorBlockWithErrorObject)errorBlock{
    
    NSMutableDictionary *parameters = [NSMutableDictionary
                                       dictionaryWithDictionary:
                                       @{@"name"        : user.name     ?: @"",
                                         @"email"       : user.email    ?: @"",
                                         @"photo"       : [UIImageJPEGRepresentation(user.photo, 0.9f)base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength] ?: @""}];
    [[super sharedClient]PUT:[NSString stringWithFormat:@"user/%lu", user.ID] parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        User *userResponse = [[User alloc] initWithDictionary:responseObject];
        
        userResponse.authorization = [User restoreFromUserDefaults].authorization;
        
        [userResponse storeInUserDefaults];
        if (successBlock) successBlock(userResponse);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (errorBlock) errorBlock(error);
    }];
    
    

}

@end
