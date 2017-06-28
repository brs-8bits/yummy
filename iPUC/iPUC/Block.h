//
//  Block.h
//  iPUC
//
//  Created by Ozeias Furtozo on 23/04/17.
//  Copyright © 2017 Barbara Santos. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Block : NSObject

typedef void (^successBlock)(Boolean success);

@property (copy) successBlock successBlock;


typedef void (^errorBlock)(Boolean error);

@property (copy) errorBlock errorBlock;


typedef void (^successBlockWithResponseObject)(id responseObject);

@property (copy) successBlockWithResponseObject successBlockWithResponseObject;


typedef void (^errorBlockWithErrorObject)(NSError * errorObject);

@property (copy) errorBlockWithErrorObject errorBlockWithErrorObject;


typedef void (^completedBlock)(Boolean completed);

@property (copy) completedBlock completedBlock;


typedef void (^errorBlockWithErrorObjectAndRequest)(NSDictionary* failedRequest, NSError * errorObject);

@property (copy) errorBlockWithErrorObjectAndRequest errorBlockWithErrorObjectAndRequest;


typedef void (^success)(NSInteger statusCode, NSString *message);

@property (copy) success success;

typedef void (^failure)(NSInteger statusCode, NSError *error, NSString *message);

@property (copy) failure failure;

@end
