//
//  User.h
//  iPUC
//
//  Created by Ozeias Furtozo on 23/04/17.
//  Copyright © 2017 Barbara Santos. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User : NSObject

@property (assign, nonatomic) NSUInteger    ID;
@property (strong, nonatomic) NSString      *name;
@property (strong, nonatomic) NSString      *email;
@property (strong, nonatomic) NSString      *password;
@property (strong, nonatomic) UIImage       *photo;
@property (strong, nonatomic) NSDate        *created_at;
@property (strong, nonatomic) NSDate        *updated_at;
@property (strong, nonatomic) NSString      *authorization;

- (instancetype)initWithDictionary:(NSDictionary*)dict;

//STORE UTIL
- (void) storeInUserDefaults;
- (BOOL) removeFromUserDefaults;
+ (User*) restoreFromUserDefaults;
//UTIL
- (NSString*)dateToString:(NSDate*)date;
- (NSDate*)stringToDate:(NSString*)string;

@end
