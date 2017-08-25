//
//  RecentSearchQuestionsVC.m
//  GoFetchCoder
//
//  Created by Guest on 1/19/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "RecentSearchQuestionsVC.h"
#import "DataManager.h"
#import "CustomCell.h"
#import "Constants.h"
#import "Question.h"
#import "NGNavigationBarMenu.h"
#import "RecentSearchAnswersVC.h"

#import "ChapterViewController.h"
#import "AppDelegate.h"
#import "RecentSearchAnswersOperation.h"
#import "RecentSearchCell.h"
#import "RecentSearchQuestionsOperation.h"
#import "UIColor+GFCAdditions.h"
#import "UIFont+GFCAdditions.h"




@interface RecentSearchQuestionsVC ()<UITableViewDataSource,UITableViewDelegate> {
    __block BOOL isSortAscending;
}

@property (nonatomic, strong)NSArray *datasource;

@property (weak, nonatomic) IBOutlet UILabel *lblSort;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIView *emptyView;
@property (weak, nonatomic) IBOutlet UIImageView *imgSort;

@end

@implementation RecentSearchQuestionsVC

//static NSString *CellIdentifier = @"RecentQuestions";
- (IBAction)btnSortAction:(id)sender {
    
    isSortAscending = !isSortAscending;
    if (isSortAscending) {
        self.imgSort.image = [UIImage imageNamed:@"i_shevron"];
    } else {
        self.imgSort.image = [UIImage imageNamed:@"i_reverse_shevron"];

    }
    
    NSArray *sortedArray;
    sortedArray = [_datasource sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(Question *)a createdDate];
        NSDate *second = [(Question*)b createdDate];
            return  isSortAscending ? [first compare:second] : [second compare:first];
    }];

    _datasource = [sortedArray copy];
//    [_table reloadData];
    [_table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

}

-(void)showEmptyScreen
{
    _emptyView.hidden = NO;
}
-(void)hideEmptyScreen
{
    _emptyView.hidden = YES;
}


-(void)downloadRecentQuestions{
    
    
    //[[DataManager sharedManager] getRecentQuestions];
    
    AppDelegate *appDelegate = kAppDelegate;
    
    RecentSearchQuestionsOperation *operation = [[RecentSearchQuestionsOperation alloc] init];
    
    operation.onCompletion = ^(NSArray *questions,BOOL isSuccess) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isSuccess) {
                _datasource = questions;
                if (_datasource.count) {
                    [self hideEmptyScreen];

                    [_table reloadData];
                }
                else {
                    [self showEmptyScreen];
                }
                
            }
            else {
//                [self showErrorAlertWithTitle:@"error" andDesription:@"error"];
                [self showErrorAlertWithTitle:kERROR_TECHNICAL_TITLE andDesription:kERROR_TECHNICAL_DESCRIPTION];

            }
            
        });
    };
    [appDelegate.queue addOperation:operation];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = kRecentQuestions;
    
    
    [self.table setSeparatorColor:[UIColor colorFromHex:@"#e3e5e7"]];
    

    _table.rowHeight = UITableViewAutomaticDimension;
     _table.estimatedRowHeight = 100;
    
    // by default : answers are coming in ascending order
    isSortAscending = YES;

    if (isSortAscending) {
        self.imgSort.image = [UIImage imageNamed:@"i_shevron"];
    } else {
        self.imgSort.image = [UIImage imageNamed:@"i_reverse_shevron"];
        
    }
    
    [_lblSort setFont:[UIFont smallTextFieldFont]];
    
    [self hideEmptyScreen];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    isSortAscending = YES;
    if (isSortAscending) {
        self.imgSort.image = [UIImage imageNamed:@"i_shevron"];
    } else {
        self.imgSort.image = [UIImage imageNamed:@"i_reverse_shevron"];
        
    }
    
    self.navigationController.navigationBarHidden = NO;
    [self downloadRecentQuestions];
    
}

#pragma UItableview delegates -

- (void)setUpCell:(RecentSearchCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Question *q = _datasource[indexPath.row];
    
   
    cell.lblQuestion.font = [UIFont fontWithName:@"Lato-Regular" size:17.0];
    cell.lblDate.font = [UIFont fontWithName:@"Lato-Regular" size:13.0];
    cell.lblLocation.font = [UIFont fontWithName:@"Lato-Regular" size:13.0];
    cell.lblQuestion.textColor = [UIColor editColor];
    cell.lblDate.textColor = [UIColor inputTextFieldColor];
    cell.lblLocation.textColor = [UIColor inputTextFieldColor];

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    cell.lblQuestion.text = q.question;
    cell.lblDate.text = [dateFormatter stringFromDate:q.createdDate];
    cell.lblLocation.text = @"South San Francisco";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"RecentSearchCell";
    UINib *nib = [UINib nibWithNibName:@"RecentSearchCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    
    RecentSearchCell *cell = (RecentSearchCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    [self setUpCell:cell atIndexPath:indexPath];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    static RecentSearchCell *cell = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        cell =(RecentSearchCell *)[tableView dequeueReusableCellWithIdentifier:@"RecentSearchCell"];
    });
    

    
    [self setUpCell:cell atIndexPath:indexPath];
    
    return [self calculateHeightForConfiguredSizingCell:cell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(RecentSearchCell *)sizingCell {
    [sizingCell layoutIfNeeded];

    CGFloat height1 = [sizingCell.lblDate systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGFloat height2 = [sizingCell.lblQuestion systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    CGFloat height3 = [sizingCell.lblLocation systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    
    CGFloat height = height1 + height2 + height3+10;
    return height;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self showLoadingIndicator];
    
    __block Question *q = _datasource[indexPath.row];
    
    if (q.questionId == -1) {
        return;
    }
    
    AppDelegate *appDelegate = kAppDelegate;
    
    RecentSearchAnswersOperation *rsaOperation = [[RecentSearchAnswersOperation alloc] init];
    rsaOperation.questionId = q.questionId;
    
    rsaOperation.onFailure = ^(NSDictionary *failureDict) {
        dispatch_async(dispatch_get_main_queue(), ^{
         //   [self showErrorAlertWithTitle:failureDict[@"searchStatus"] andDesription:failureDict[@"message"]];
            [self showErrorAlertWithTitle:kERROR_TECHNICAL_TITLE andDesription:kERROR_TECHNICAL_DESCRIPTION];

        });
    };
    
    rsaOperation.onSuccess = ^(NSArray *answers) {
        NSLog(@"%@",answers);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            RecentSearchAnswersVC *vc = [[RecentSearchAnswersVC alloc] initWithNibName:NSStringFromClass([RecentSearchAnswersVC class]) bundle:nil];
            vc.answers = answers;
            vc.question = q.question;

            [self.navigationController pushViewController:vc animated:YES];
        });
        
        
    };
    
    
    [appDelegate.queue addOperation:rsaOperation];
    
}



@end
