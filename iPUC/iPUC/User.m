//
//  User.m
//  iPUC
//
//  Created by Ozeias Furtozo on 23/04/17.
//  Copyright © 2017 Barbara Santos. All rights reserved.
//

#import "User.h"

@implementation User

static User * sharedUser;

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        _ID             = [dict[@"id"] integerValue];
        _name           = dict[@"name"];
        _password       = dict[@"password"];
        _email          = dict[@"email"];
        
        NSData *data    = [[NSData alloc] initWithBase64EncodedData:dict[@"photo"] ?: @"" options:NSDataBase64DecodingIgnoreUnknownCharacters];
        _photo          = [[UIImage alloc] initWithData:data];
        
        _updated_at     = [self stringToDate:dict[@"updated_at"]];
        _created_at     = [self stringToDate:dict[@"created_at"]];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:@(_ID)                 forKey:@"ID"];
    [aCoder encodeObject:_name                  forKey:@"name"];
    [aCoder encodeObject:_password              forKey:@"password"];
    [aCoder encodeObject:_email                 forKey:@"email"];
    
    [aCoder encodeObject:[UIImageJPEGRepresentation(_photo, 0.f) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength] forKey:@"photo"];
    
    [aCoder encodeObject:_created_at            forKey:@"created_at"];
    [aCoder encodeObject:_updated_at            forKey:@"updated_at"];
    [aCoder encodeObject:_authorization         forKey:@"authorization"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if((self = [super init]))
    {
        _ID                 = [[aDecoder decodeObjectForKey:@"ID"] integerValue];
        _name               = [aDecoder decodeObjectForKey:@"name"];
        _email              = [aDecoder decodeObjectForKey:@"email"];
        _password           = [aDecoder decodeObjectForKey:@"password"];
        
        NSData *data        = [[NSData alloc] initWithBase64EncodedData:[aDecoder decodeObjectForKey:@"photo"] ?: @"" options:NSDataBase64DecodingIgnoreUnknownCharacters];
        _photo              = [[UIImage alloc] initWithData:data];
        
        _created_at         = [aDecoder decodeObjectForKey:@"created_at"];
        _updated_at         = [aDecoder decodeObjectForKey:@"updated_at"];
        _authorization      = [aDecoder decodeObjectForKey:@"authorization"];
    }
    return self;
}

- (void)storeInUserDefaults{
    NSData *encodedObject       = [NSKeyedArchiver archivedDataWithRootObject:self];
    NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
    [defaults setObject:encodedObject forKey:@"user"];
    [defaults synchronize];
}

+ (User *)restoreFromUserDefaults{
    NSUserDefaults *defaults    = [NSUserDefaults standardUserDefaults];
    NSData *encodedObject       = [defaults objectForKey:@"user"];
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    return user;
}

- (BOOL)removeFromUserDefaults{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"user"];
    return [defaults synchronize];
}

- (NSString*)dateToString:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    //FIX DATE 12 TO 24
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:locale];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    NSString *stringDate = [dateFormatter stringFromDate:date];
    return stringDate;
}

- (NSDate*)stringToDate:(NSString*)string{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    NSDate *dateFromString = [[NSDate alloc] init];
    dateFromString = [dateFormatter dateFromString:string];
    
    return dateFromString;
}

@end
