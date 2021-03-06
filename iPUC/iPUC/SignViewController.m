//
//  SignViewController.m
//  iPUC
//
//  Created by Ozeias Furtozo on 30/04/17.
//  Copyright © 2017 Barbara Santos. All rights reserved.
//

#import "SignViewController.h"
#import "UserViewController.h"
#import "User.h"
#import "titleTableViewCell.h"
#import "titleFieldTableViewCell.h"
#import "Form.h"
#import "AvatarTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "JTProgressHUD.h"
#import "UserBusiness.h"
#import "JTAlertView.h"

@interface SignViewController ()<UITableViewDelegate, UITableViewDataSource, titleFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(strong, nonatomic) NSMutableArray *form;




@end

@implementation SignViewController{
    CGFloat fixedHeight;
    UITableViewCell *temCell;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Cadastrar";
    
    User *user = [User restoreFromUserDefaults];
    _form = [[NSMutableArray alloc] init];
    
    Form *avatar = [[Form alloc] init];
    avatar.type = AVATAR;
    avatar.value = [UIImage imageNamed:@"form_camera"];
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
    
    Form *save= [[Form alloc] init];
    save.type = SAVE;
    [_form addObject: save];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)keyboardDidShow:(NSNotification *)notif{
    NSDictionary* d = [notif userInfo];
    CGRect r = [d[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.bottomDistance.constant = r.size.height;
}

- (void)keyboardWillHide:(NSNotification *)notif{
    self.bottomDistance.constant = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - titleFieldDelegate
- (void)titleFieldDidBeginEditing:(UITableViewCell *)titleFieldTableViewCell{
    [self.tableView scrollToRowAtIndexPath:[self.tableView indexPathForCell:titleFieldTableViewCell] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _form.count;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[self performSegueWithIdentifier:@"goToReceita" sender:[_data objectAtIndex:indexPath.row]];
    
    Form *form = [_form objectAtIndex:indexPath.row];
    
    switch (form.type) {
        case SAVE:{
            
            User *user = [[User alloc] init];
            UIImage *avatar = [[UIImage alloc] init];
            for(int i = 0; i < _form.count; i++){
                NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:0];
                Form *form = [_form objectAtIndex:index.row];
                
                switch (form.type) {
                    case AVATAR:{
                        AvatarTableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
                        avatar = cell.avatar.image;
                        break;
                    }
                    case NAME:{
                        titleFieldTableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
                        user.name = cell.titleField.text;
                        break;
                    }
                    case EMAIL:{
                        titleFieldTableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
                        user.email = cell.titleField.text;
                        break;
  
                    }
                    case PASSWORD:{
                        titleFieldTableViewCell *cell = [self.tableView cellForRowAtIndexPath:index];
                        user.password = cell.titleField.text;
                        break;
                    }
                    default:
                        break;
                }
            }
            
            
            [JTProgressHUD show];
            [UserBusiness signupUser:user withSuccess:^(id responseObject) {
                [JTProgressHUD hide];
                
                [self performSegueWithIdentifier:@"goToAPP" sender:nil];
                NSLog(@"SUCCESS REQUEST");
            } orFail:^(NSError *errorObject) {
                [JTProgressHUD hide];
                JTAlertView *alertView = [[JTAlertView alloc] initWithTitle:@"ERROR" andImage:[UIImage imageNamed:@"color_bars_start"]];
                alertView.size = CGSizeMake(280, 230);
                alertView.backgroundShadow = YES;
                
                
                [alertView addButtonWithTitle:@"OK" style:JTAlertViewStyleDefault action:^(JTAlertView *alertView) {
                    [alertView hide];
                }];
                
                [alertView show];
                
            }];
            
            break;
        }
        default:
            break;
    }
    
    //Change the selected background view of the cell.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Form *form = [_form objectAtIndex:indexPath.row];
    
    switch (form.type) {
        case AVATAR:{
            
            static NSString *simpleTableIdentifier = @"avatarCell";
            
            AvatarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"AvatarTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.viewController = self;
            if([form.value isKindOfClass:[UIImage class]]){
                cell.avatar.image = form.value;
            }else{
                [cell.avatar sd_setImageWithURL:[NSURL URLWithString:form.value]];
            }
            
            return cell;
            
        }
        case NAME:{
            
            static NSString *simpleTableIdentifier = @"titleFieldCell";
            
            titleFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"titleFieldTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.titleField.placeholder = @"Nome";
            cell.titleField.text = form.value;
            cell.image.image = [UIImage imageNamed:@"user"];
            cell.delegate = self;
            return cell;
            
        }
        case EMAIL:{ static NSString *simpleTableIdentifier = @"titleFieldCell";
            
            titleFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"titleFieldTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.titleField.placeholder = @"E-mail";
            cell.titleField.text = form.value;
            cell.image.image = [UIImage imageNamed:@"email"];
            cell.delegate = self;
            
            return cell;
        }
        case PASSWORD:{
            static NSString *simpleTableIdentifier = @"titleFieldCell";
            
            titleFieldTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"titleFieldTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.titleField.placeholder = @"Password";
            cell.titleField.text = form.value;
            cell.image.image = [UIImage imageNamed:@"password"];
            cell.titleField.secureTextEntry = YES;
            cell.delegate = self;

            return cell;
        }
        case SAVE:{
            static NSString *simpleTableIdentifier = @"titleCell";
            
            titleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
            
            if (cell == nil) {
                NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"titleTableViewCell" owner:self options:nil];
                cell = [nib objectAtIndex:0];
            }
            cell.title.textAlignment = NSTextAlignmentCenter;
            cell.title.text = @"Salvar";
            return cell;
        }
        default:
            return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Form *form = [_form objectAtIndex:indexPath.row];
    
    switch (form.type) {
        case AVATAR:{
            return [UIScreen mainScreen].bounds.size.width;
        }
        default:
            return 44;
    }
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
