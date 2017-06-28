//
//  Receita.m
//  iPUC
//
//  Created by Ozeias Furtozo on 25/04/17.
//  Copyright © 2017 Barbara Santos. All rights reserved.
//

#import "Receita.h"
#import "Ingredient.h"

@implementation Receita

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        _ID         = [dict[@"id"] integerValue];
        _title       = dict[@"title"];
        _photo       = dict[@"photo"];
        _prepare_mode  = dict[@"prepare_mode"];
        _user = [[User alloc] initWithDictionary:dict[@"user"]];
        _updated_at = [_user stringToDate:dict[@"updated_at"]];
        _created_at = [_user stringToDate:dict[@"created_at"]];
        
        _ingredients = [[NSMutableArray alloc] init];
        //mutableCopy transforma um array em um mutableArray
        for(NSString *ingredient_string in [dict[@"ingredients"] componentsSeparatedByString:@","]){
            Ingredient *ingredient = [[Ingredient alloc] init];
            ingredient.title = ingredient_string;
            ingredient.isChecked = NO;
            
            [_ingredients addObject:ingredient];
        }
        _isFavorite = [dict[@"isFavorite"] boolValue];
        
    }
    return self;
}


@end
