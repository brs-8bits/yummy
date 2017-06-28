//
//  textTableViewCell.m
//  iPUC
//
//  Created by Ozeias Furtozo on 25/04/17.
//  Copyright © 2017 Barbara Santos. All rights reserved.
//

#import "textTableViewCell.h"

@implementation textTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGFloat)setAutoHeightTextView:(NSString*)text{
    [_prepare_mode setFont:[UIFont systemFontOfSize:17]];
    [_prepare_mode setScrollEnabled:NO];
    [_prepare_mode setEditable:NO];
    [_prepare_mode setText:text];
    [_prepare_mode sizeToFit];
    
    CGFloat height = _prepare_mode.contentSize.height;
    _prepare_mode.frame = CGRectMake(44, 8, [UIScreen mainScreen].bounds.size.width - 56, height);
    return height;
}
@end
