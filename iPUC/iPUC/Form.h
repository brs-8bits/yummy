//
//  Form.h
//  iPUC
//
//  Created by Ozeias Furtozo on 30/04/17.
//  Copyright © 2017 Barbara Santos. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, formType)
{
    AVATAR,
    NAME,
    EMAIL,
    PASSWORD,
    ADDRECEITA,
    SAVE,
    LOGOUT,
    TITLE,
    MODE_PREPARE
    
};

@interface Form : NSObject

@property (assign, nonatomic) formType          type;
@property (strong, nonatomic) id                value;

@end
