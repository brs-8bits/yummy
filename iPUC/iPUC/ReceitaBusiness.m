//
//  ReceitaBusiness.m
//  iPUC
//
//  Created by Ozeias Furtozo on 01/05/17.
//  Copyright © 2017 Barbara Santos. All rights reserved.
//

#import "ReceitaBusiness.h"

@implementation ReceitaBusiness

+(void)getReceitas:(successBlockWithResponseObject)successBlock
           orFail:(errorBlockWithErrorObject)errorBlock{

    
    [[super sharedClient] GET:@"recipe/new/0" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
      
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *receitas = [[NSMutableArray alloc ] init];
        for (NSDictionary *dict in responseObject) {
            Receita *receita = [[Receita alloc]initWithDictionary:dict];
            [receitas addObject:receita];
        }
        if (successBlock) successBlock(receitas);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (errorBlock) errorBlock(error);
    }];
}

+(void)postClick:(Receita *)receita withSuccess:(successBlockWithResponseObject)successBlock orFail:(errorBlockWithErrorObject)errorBlock{

    [[super sharedClient] POST:[NSString stringWithFormat:@"recipe/%lu/view", receita.ID] parameters: nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        Receita *receita = [[Receita alloc]initWithDictionary:responseObject];
        if (successBlock) successBlock(receita);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (errorBlock) errorBlock(error);
    }];
    
}

+(void)getTopReceitas:(successBlockWithResponseObject)successBlock
            orFail:(errorBlockWithErrorObject)errorBlock{
    
    
    [[super sharedClient] GET:@"recipe/top/0" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *receitas = [[NSMutableArray alloc ] init];
        for (NSDictionary *dict in responseObject) {
            Receita *receita = [[Receita alloc]initWithDictionary:dict];
            [receitas addObject:receita];
        }
        if (successBlock) successBlock(receitas);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (errorBlock) errorBlock(error);
    }];
}

+(void)postReceita:(Receita *)receita withSuccess:(successBlockWithResponseObject)successBlock
            orFail:(errorBlockWithErrorObject)errorBlock{
    
    NSMutableDictionary *parameters = [NSMutableDictionary
                                       dictionaryWithDictionary:
                                       @{@"user_id"      : [NSString stringWithFormat:@"%lu", [User restoreFromUserDefaults].ID],
                                         @"title"        : receita.title     ?: @"",
                                         @"prepare_mode" : receita.prepare_mode ?: @"",
                                         @"ingredients"  : [ receita.ingredients componentsJoinedByString:@","],
                                         @"photo"        : [UIImageJPEGRepresentation(receita.photo, 0.9f)base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength] ?: @""}];
    
    [[super sharedClient] POST:@"recipe" parameters: parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) successBlock(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (errorBlock) errorBlock(error);
    }];
}


+(void)getFavoritesReceitas:(successBlockWithResponseObject)successBlock
                     orFail:(errorBlockWithErrorObject)errorBlock{
    
    [[super sharedClient] GET:@"favorites" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *receitas = [[NSMutableArray alloc ] init];
        for (NSDictionary *dict in responseObject) {
            Receita *receita = [[Receita alloc]initWithDictionary:dict];
            [receitas addObject:receita];
        }
        
        if (successBlock) successBlock(receitas);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (errorBlock) errorBlock(error);
    }];
}

+(void) postFavorite:(Receita *)receita withSuccess:(successBlockWithResponseObject)successBlock
              orFail:(errorBlockWithErrorObject)errorBlock{
    
    [[super sharedClient] POST:[NSString stringWithFormat:@"recipe/%lu/favorite", receita.ID] parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) successBlock(responseObject);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         if (errorBlock) errorBlock(error);
    }];

}

+(void) deleteFavorite:(Receita *)receita withSuccess:(successBlockWithResponseObject)successBlock
              orFail:(errorBlockWithErrorObject)errorBlock{
    
    [[super sharedClient] DELETE:[NSString stringWithFormat:@"recipe/%lu/favorite", receita.ID] parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (successBlock) successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (errorBlock) errorBlock(error);
    }];
    
}

@end
