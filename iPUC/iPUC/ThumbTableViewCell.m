//
//  ThumbTableViewCell.m
//  iPUC
//
//  Created by Ozeias Furtozo on 24/04/17.
//  Copyright © 2017 Barbara Santos. All rights reserved.
//

#import "ThumbTableViewCell.h"

@implementation ThumbTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _avatar.layer.masksToBounds = YES;
    _avatar.layer.cornerRadius = 20.0;
    _avatar.layer.borderWidth = 1.0;
    _avatar.layer.borderColor = [[UIColor grayColor] CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
