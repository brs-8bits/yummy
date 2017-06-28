//
//  UserBusiness.h
//  iPUC
//
//  Created by Ozeias Furtozo on 23/04/17.
//  Copyright © 2017 Barbara Santos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIClient.h"
#import "User.h"

@interface UserBusiness : APIClient

+(void)signinUser:(User*)user
      withSuccess:(successBlockWithResponseObject)successBlock
           orFail:(errorBlockWithErrorObject)errorBlock;

+(void)logoutUser:(User*)user
       withSucess:(successBlockWithResponseObject)sucessBlock;

+(void)signupUser:(User*)user
      withSuccess:(successBlockWithResponseObject)successBlock
           orFail:(errorBlockWithErrorObject)errorBlock;

+(void)putUser:(User*)user
      withSuccess:(successBlockWithResponseObject)successBlock
           orFail:(errorBlockWithErrorObject)errorBlock;
@end
