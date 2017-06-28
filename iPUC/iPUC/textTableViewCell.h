//
//  textTableViewCell.h
//  iPUC
//
//  Created by Ozeias Furtozo on 25/04/17.
//  Copyright © 2017 Barbara Santos. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface textTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *prepare_mode;

- (CGFloat)setAutoHeightTextView:(NSString*)text;

@end
