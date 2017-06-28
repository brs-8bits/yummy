//
//  AvatarTableViewCell.h
//  iPUC
//
//  Created by Ozeias Furtozo on 29/04/17.
//  Copyright © 2017 Barbara Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AvatarTableViewCell : UITableViewCell

@property(weak, nonatomic) IBOutlet UIImageView *avatar;

@property(weak, nonatomic) UIViewController *viewController;

@end
