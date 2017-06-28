//
//  ThumbTableViewCell.h
//  iPUC
//
//  Created by Ozeias Furtozo on 24/04/17.
//  Copyright © 2017 Barbara Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThumbTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *title;

@end
