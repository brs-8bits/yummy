//
//  LoginViewController.m
//  iPUC
//
//  Created by Ozeias Furtozo on 23/04/17.
//  Copyright © 2017 Barbara Santos. All rights reserved.
//

#import "LoginViewController.h"
#import "UserBusiness.h"
#import "JTAlertView.h"
#import "JTProgressHUD.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIImageView *fundo;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Login";
    _fundo.image = [UIImage imageNamed:@"bruscretta"];
    _email.delegate = self;
    _password.delegate = self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)singin:(id)sender{
    User *user = [[User alloc] init];
    
    user.email = _email.text;
    user.password = _password.text;
    
    [JTProgressHUD show];
    [UserBusiness signinUser:user withSuccess:^(id responseObject) {
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
}

- (IBAction)singup:(id)sender{
    
    
    [self performSegueWithIdentifier:@"gotoSignup" sender:nil];

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
