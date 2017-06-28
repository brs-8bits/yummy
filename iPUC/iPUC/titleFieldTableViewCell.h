//
//  titleFieldTableViewCell.h
//  iPUC
//
//  Created by Ozeias Furtozo on 29/04/17.
//  Copyright © 2017 Barbara Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol titleFieldDelegate <NSObject>

@optional

- (void)titleFieldDidBeginEditing:(UITableViewCell *)titleFieldTableViewCell;

@end

@interface titleFieldTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *titleField;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) id<titleFieldDelegate> delegate;


@end
