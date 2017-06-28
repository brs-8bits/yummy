//
//  AvatarTableViewCell.m
//  iPUC
//
//  Created by Ozeias Furtozo on 29/04/17.
//  Copyright © 2017 Barbara Santos. All rights reserved.
//

#import "AvatarTableViewCell.h"

@interface AvatarTableViewCell ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@end

@implementation AvatarTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhoto:)];
    singleTap.numberOfTapsRequired = 1;
    [_avatar setUserInteractionEnabled:YES];
    [_avatar addGestureRecognizer:singleTap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(IBAction)takePhoto:(id)sender{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
    [_viewController presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker
        didFinishPickingImage:(UIImage *)image
                  editingInfo:(NSDictionary *)editingInfo
{
    // Dismiss the image selection, hide the picker and
    
    //show the image view with the picked image
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    _avatar.image = image;
}
@end
