//
//  APPViewController.m
//  iPUC
//
//  Created by Ozeias Furtozo on 23/04/17.
//  Copyright © 2017 Barbara Santos. All rights reserved.
//

#import "APPViewController.h"
#import "User.h"
#import "UserBusiness.h"
#import "JTProgressHUD.h"
#import "ThumbTableViewCell.h"
#import "ThumbDetailsViewController.h"
#import "JTProgressHUD.h"
#import "Receita.h"
#import "ReceitaBusiness.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface APPViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) UIRefreshControl *refresh;

@end


@implementation APPViewController{

    NSArray *tableData;
    NSArray *thumbnails;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _data = [[NSMutableArray alloc] init];
    // Do any additional setup after loading the view.
    self.title = @"Novas Receitas";
    User *user = [User restoreFromUserDefaults];
    _emailLabel.text = user.email;
    _refresh = [[UIRefreshControl alloc] init];
    [_refresh addTarget:self action:@selector(getData) forControlEvents: UIControlEventValueChanged];
    _tableView.refreshControl = _refresh;
    [self getData];
}

-(void)getData{
    [ReceitaBusiness getReceitas:^(id responseObject) {
        _data = [[NSMutableArray alloc] init];
        _data = responseObject;
        [_refresh endRefreshing];
        [_tableView reloadData];
    } orFail:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender{
    User *user = [User restoreFromUserDefaults];
    
    [JTProgressHUD show];
    [UserBusiness logoutUser: user withSucess:^(id responseObject) {
        [JTProgressHUD hide];
        [self performSegueWithIdentifier:@"logout" sender:nil];
        NSLog(@"SUCESS LOGOUT");
    }];
    
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_data count];
}

#pragma mark - UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"thumbnailCell";
    
    ThumbTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ThumbTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    Receita * receita = [_data objectAtIndex:indexPath.row];
    
    cell.title.text = receita.title;
    [cell.thumbnail sd_setImageWithURL:[NSURL URLWithString:receita.photo]];
    cell.avatar.image = receita.user.photo;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 193;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"goToReceita" sender:[_data objectAtIndex:indexPath.row]];
    //Change the selected background view of the cell.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"goToReceita"]) {
        
        ThumbDetailsViewController *destViewController = segue.destinationViewController;
        destViewController.receita = sender;
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
