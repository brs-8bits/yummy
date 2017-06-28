//
//  ThumbDetailsViewController.m
//  iPUC
//
//  Created by Ozeias Furtozo on 25/04/17.
//  Copyright © 2017 Barbara Santos. All rights reserved.
//

#import "ThumbDetailsViewController.h"
#import "ThumbTableViewCell.h"
#import "User.h"
#import "titleTableViewCell.h"
#import "textTableViewCell.h"
#import "buttonTableViewCell.h"
#import "ingredientTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ReceitaBusiness.h"

@interface ThumbDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ThumbDetailsViewController{
    CGFloat fixedHeight;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = _receita.title;
    [ReceitaBusiness postClick:_receita withSuccess:nil orFail:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (1 + 1 + _receita.ingredients.count + 1 + 1 + 1);
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //[self performSegueWithIdentifier:@"goToReceita" sender:[_data objectAtIndex:indexPath.row]];
    
    if(indexPath.row > 1 && indexPath.row < 2 + _receita.ingredients.count){
        Ingredient *ingrediente = [_receita.ingredients objectAtIndex: indexPath.row - 2];
        ingrediente.isChecked = !ingrediente.isChecked;
        
        [_receita.ingredients setObject:ingrediente atIndexedSubscript:indexPath.row - 2];
        [_tableView reloadData];
    }else if(indexPath.row == 2 + _receita.ingredients.count + 2){
        
        if(_receita.isFavorite == YES){
             [ReceitaBusiness deleteFavorite:_receita withSuccess:nil orFail:nil];
        
        }else{
            
            [ReceitaBusiness postFavorite:_receita withSuccess:nil orFail:nil];
        }
         _receita.isFavorite = !_receita.isFavorite;
         [_tableView reloadData];
    }
    
    //Change the selected background view of the cell.
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        static NSString *simpleTableIdentifier = @"thumbnailCell";
        
        ThumbTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ThumbTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.title.text = _receita.title;
        [cell.thumbnail sd_setImageWithURL:[NSURL URLWithString:_receita.photo]];
        cell.avatar.image = _receita.user.photo?:nil;
        return cell;
    }else if(indexPath.row == 1){
        static NSString *simpleTableIdentifier = @"titleCell";
        
        titleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"titleTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.title.text = @"Ingredientes:";
        return cell;
        
    }else if(indexPath.row > 1 && indexPath.row < 2 + _receita.ingredients.count){
        static NSString *simpleTableIdentifier = @"ingredientCell";
        
        ingredientTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ingredientTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        Ingredient *ingrediente = [_receita.ingredients objectAtIndex: indexPath.row - 2];
        
        
        cell.checkList.image = ingrediente.isChecked ? [UIImage imageNamed:@"checked"] : [UIImage imageNamed:@"check"];
        cell.titleIngredient.text = [NSString stringWithFormat:@ "%@", ingrediente.title];
        return cell;
    }else if(indexPath.row == 2 + _receita.ingredients.count){
        static NSString *simpleTableIdentifier = @"titleCell";
        
        titleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"titleTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.title.text = @"Modo de preparo:";
        return cell;
    }else if(indexPath.row == 2 + _receita.ingredients.count + 1){
        static NSString *simpleTableIdentifier = @"textCell";
        
        textTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"textTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
            
        }
        [cell.prepare_mode setScrollEnabled:NO];
        [cell.prepare_mode setText:_receita.prepare_mode];
        [cell.prepare_mode sizeToFit];
        
        fixedHeight = 80;
        fixedHeight = [cell setAutoHeightTextView:_receita.prepare_mode];
        //cell.title.text = _receita.prepare_mode;
        return cell;
        
    }else{
        static NSString *simpleTableIdentifier = @"buttonCell";
        
        buttonTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if (cell == nil) {
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"buttonTableViewCell" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        cell.inlove.image = _receita.isFavorite ? [UIImage imageNamed:@"loved"] : [UIImage imageNamed:@"love"];

        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return 193;
    }else if(indexPath.row == 1){
        return 44;
    }else if(indexPath.row > 1 && indexPath.row < 2 + _receita.ingredients.count){
        return 44;
    }else if(indexPath.row == 2 + _receita.ingredients.count){
        return 44;
    }else if(indexPath.row == 2 + _receita.ingredients.count + 1){
        return fixedHeight;
    }else{
        return 44;
    }
    return 0;
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
