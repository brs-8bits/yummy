//
//  Receita.h
//  iPUC
//
//  Created by Ozeias Furtozo on 25/04/17.
//  Copyright © 2017 Barbara Santos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "Ingredient.h"

@interface Receita : NSObject

@property (assign, nonatomic) NSUInteger        ID;
@property (strong, nonatomic) NSString          *title;
@property (strong, nonatomic) User              *user;
@property (strong, nonatomic) UIImage           *photo;
@property (strong, nonatomic) NSString          *prepare_mode;
@property (strong, nonatomic) NSMutableArray    *ingredients;
@property (strong, nonatomic) NSDate            *created_at;
@property (strong, nonatomic) NSDate            *updated_at;
@property (assign, nonatomic) BOOL              isFavorite;

- (instancetype)initWithDictionary:(NSDictionary*)dict;

@end
