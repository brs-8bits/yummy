//
//  ReceitaBusiness.h
//  iPUC
//
//  Created by Ozeias Furtozo on 01/05/17.
//  Copyright © 2017 Barbara Santos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "APIClient.h"
#import "Receita.h"

@interface ReceitaBusiness : APIClient

+(void)getReceitas:(successBlockWithResponseObject)successBlock
           orFail:(errorBlockWithErrorObject)errorBlock;

+(void)postClick:(Receita*)receita
      withSuccess:(successBlockWithResponseObject)successBlock
           orFail:(errorBlockWithErrorObject)errorBlock;

+(void)getTopReceitas:(successBlockWithResponseObject)successBlock
            orFail:(errorBlockWithErrorObject)errorBlock;

+(void)postReceita:(Receita*)receita
        withSuccess:(successBlockWithResponseObject)successBlock
             orFail:(errorBlockWithErrorObject)errorBlock;


+(void)getFavoritesReceitas:(successBlockWithResponseObject)successBlock
               orFail:(errorBlockWithErrorObject)errorBlock;

+(void)postFavorite:(Receita*)receita
     withSuccess:(successBlockWithResponseObject)successBlock
          orFail:(errorBlockWithErrorObject)errorBlock;

+(void)deleteFavorite:(Receita*)receita
        withSuccess:(successBlockWithResponseObject)successBlock
             orFail:(errorBlockWithErrorObject)errorBlock;
@end
