//
//  AddReceitaViewController.m
//  iPUC
//
//  Created by Ozeias Furtozo on 29/05/17.
//  Copyright © 2017 Barbara Santos. All rights reserved.
//

#import "AddReceitaViewController.h"
#import "Form.h"
#import "AvatarTableViewCell.h"
#import "Receita.h"
#import "User.h"

@interface AddReceitaViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong, nonatomic) NSMutableArray *form;

@end

@implementation AddReceitaViewController{
    CGFloat fixedHeight;
}

- (void)viewDidLoad {
    
    User *user = [User restoreFromUserDefaults];
    _form = [[NSMutableArray alloc] init];
    
    Form *avatar = [[Form alloc] init];
    avatar.type = AVATAR;
    avatar.value = user.photo;
    [_form addObject: avatar];
    
    Form *name = [[Form alloc] init];
    name.type = NAME;
    name.value = user.name;
    [_form addObject: name];
    
    Form *email= [[Form alloc] init];
    email.type = EMAIL;
    email.value = user.email;
    [_form addObject: email];
    
    Form *password = [[Form alloc] init];
    password.type = PASSWORD;
    password.value = user.password;
    [_form addObject: password];
    
    Form *addReceita= [[Form alloc] init];
    addReceita.type = ADDRECEITA;
    [_form addObject: addReceita];
    
    Form *save= [[Form alloc] init];
    save.type = SAVE;
    [_form addObject: save];
    
    Form *logout= [[Form alloc] init];
    logout.type = LOGOUT;
    [_form addObject: logout];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
