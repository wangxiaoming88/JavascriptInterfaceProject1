//
//  GlobalNavigationVC.m
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 3/5/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "GlobalNavigationVC.h"
#import "GlobalNavigationCell.h"
#import "UIColor+GFCAdditions.h"
#import "Constants.h"

@interface GlobalNavigationVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)NSMutableArray *datasource;
@property (nonatomic, strong)NSMutableArray *imagesource;
//@property (nonatomic,assign)NSIndexPath *selectedCellIndexPath;
@end


@implementation GlobalNavigationVC


- (IBAction)dismiss:(id)sender
{
    [self.delegate didHideGlobalNav];
}
    
-(void)viewDidLayoutSubviews
{
    [self.view layoutIfNeeded];
 //   [self highlightSelectedCell];
}

-(void)highlightSelectedCell {
    
    NSInteger currentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:kCurrentSelectedMenuIndex];
    [_table selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datasource.count;
}

/*- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    GlobalNavigationCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.imageView.image = [UIImage imageNamed:_imagesource[indexPath.row]];
    cell.lblText.textColor= [UIColor colorFromHex:@"#29b866"];
    
}*/


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    GlobalNavigationCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self.delegate didSelectItem:cell.lblText.text AtIndex:indexPath.row];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"GlobalNavigationCell";
    
    GlobalNavigationCell *cell = (GlobalNavigationCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
   
    cell.lblText.text              = _datasource[indexPath.row];
    cell.imageView.image           = [UIImage imageNamed:_imagesource[indexPath.row]];
    cell.selectedImageName         = [NSString stringWithFormat:@"%@_active",_imagesource[indexPath.row]];
    cell.unSelectedImageName       = _imagesource[indexPath.row];

    
    
    return cell;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
   
    _datasource = [NSMutableArray arrayWithObjects:
                   @"SEARCH",
                   kRecentQuestions,
                   kBookmarks,
                   kCBC,
                   kMessages,
                   kMyAccount,
                   kHelp,
                   nil];
    
    _imagesource = [NSMutableArray arrayWithObjects:
                   @"i_search",
                   @"i_searches",
                   @"i_bookmark",
                   @"i_browse",
                   @"i_clarify",
                   @"i_account",
                   @"i_help",
                   nil];
    
    [self.table registerNib:[UINib nibWithNibName:@"GlobalNavigationCell" bundle:nil] forCellReuseIdentifier:@"GlobalNavigationCell"];
    
    _table.estimatedRowHeight = 50;
    _table.rowHeight = 50;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self performSelector:@selector(highlightSelectedCell) withObject:nil afterDelay:0.2];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
