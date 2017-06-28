//
//  titleFieldTableViewCell.m
//  iPUC
//
//  Created by Ozeias Furtozo on 29/04/17.
//  Copyright © 2017 Barbara Santos. All rights reserved.
//

#import "titleFieldTableViewCell.h"
@interface titleFieldTableViewCell ()<UITextFieldDelegate>

@end

@implementation titleFieldTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _titleField.delegate = self;
    _titleField.returnKeyType = UIReturnKeyDone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if ([self.delegate respondsToSelector:@selector(titleFieldDidBeginEditing:)])
        [self.delegate titleFieldDidBeginEditing:self];
}

@end
