//
//  HelpVC.m
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 3/4/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "HelpVC.h"
#import "HelpCell.h"

@interface HelpVC ()<UITableViewDataSource,UITableViewDelegate>{

}


@property (weak, nonatomic) IBOutlet UITableView *table;

@property (nonatomic, strong)NSArray *datasource;

@property (weak, nonatomic) IBOutlet UIView *footerView;


@end

static NSString *CellIdentifier = @"HelpCell";

@implementation HelpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    static NSString *CellIdentifier = @"HelpCell";

    [self.table registerNib:[UINib nibWithNibName:NSStringFromClass([HelpCell class]) bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
    [self setup];
    
    
}

-(void)setup
{
    _table.estimatedRowHeight = 45;
    _table.rowHeight = UITableViewAutomaticDimension;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];

    _datasource = [NSArray arrayWithObjects:
                   @"Finish materials",
                   @"Dietary and food preparations areas.",
                   @"Research and investigation",
                   @"Evaluation and follow-up inspection services",
                   nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UItableview delegates -
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return _footerView.frame.size.height;
//}
//
//- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    return _footerView;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HelpCell *cell = (HelpCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.lblNumber.text = [NSString stringWithFormat:@"%ld",indexPath.row + 1];
    cell.lblText.text   = _datasource[indexPath.row];

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   // [self showLoadingIndicator];
    
}





@end
