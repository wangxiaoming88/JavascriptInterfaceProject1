//
//  RecentSearchAnswersVC.m
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 1/21/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "RecentSearchAnswersVC.h"

#import "RecentSearchAnswer.h"
#import "CustomCell.h"
#import "Constants.h"
#import "DataManager.h"
#import "Answer.h"

#import "GCFAPIClient.h"
#import "ChapterViewController.h"
#import "SectionsViewController.h"
#import "RecentSectionViewController.h"

@interface RecentSearchAnswersVC ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UILabel *labelQuestion;


@property (nonatomic, strong)NSMutableArray *datasource;
@property (nonatomic, strong)NSString *selectedSectionNUmber;


@end

@implementation RecentSearchAnswersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _table.delegate =self;
    _table.dataSource = self;
    _labelQuestion.text = _question;
    
    
    _datasource = [NSMutableArray arrayWithArray:_answers];
    [_datasource addObject:@"IBMLogo"];

    self.navigationItem.title = @"Recent Answers";
    
    
    [self.table registerNib:[UINib nibWithNibName:@"LogoCell"
                                           bundle:[NSBundle mainBundle]]
     forCellReuseIdentifier:@"LogoCell"];
    
    
    [self.table registerNib:[UINib nibWithNibName:@"CustomCell"
                                           bundle:[NSBundle mainBundle]]
     forCellReuseIdentifier:@"CustomCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma UItableview delegates -

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datasource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row+1 == _datasource.count) {
        return 60;
    }
    return 177;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CustomCell";
    
    static NSString *LogoCellIdentifier = @"LogoCell";
    
    if (indexPath.row +1  == _datasource.count) {
        UITableViewCell *logoCell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:LogoCellIdentifier];
        return logoCell;
    }

    
    CustomCell *cell = (CustomCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    RecentSearchAnswer *a = _datasource[indexPath.row];
    
//    cell.labelSectionNumber.text = [NSString stringWithFormat:@"%@ %@",a.sectionSequenceId,a.sectionSequenceTitle] ;
    cell.labelSectionNumber.text = [NSString stringWithFormat:@"%@ %@",a.sectionSequenceId != nil ? a.sectionSequenceId:@"",a.sectionSequenceTitle != nil ? a.sectionSequenceTitle:@""] ;

    cell.labelBestMatch.text     = a.score == kMaxScore ? @"Best Match" : @"";

    cell.labelAnswer.text        = a.body;
    
    return cell;
}



-(void)showRecentSectionScreen:(Answer *)a {
    
    [self hideLoadingIndicator];
    
    RecentSectionViewController *vc = [[RecentSectionViewController alloc] initWithNibName:NSStringFromClass([RecentSectionViewController class]) bundle:nil];
    
    vc.hyperlink            = a.hyperlink;
    vc.chapterNo            =a.chapterNo;
    vc.sectionSequenceId    = a.sectionNumber;
    vc.sectionSequenceTitle = a.sectionName;
    
    vc.searchQuestion = _labelQuestion.text;
    [self.navigationController pushViewController:vc animated:YES];

}


-(void)loadSearchScreen:(NSArray *)array {
    
    [self hideLoadingIndicator];
    
    
    SectionsViewController *vc = [[SectionsViewController alloc] initWithNibName:NSStringFromClass([SectionsViewController class]) bundle:nil];
    vc.answersArray = array;
    vc.searchQuestion = _question;

    [self.navigationController pushViewController:vc animated:YES];
    
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self showLoadingIndicator];
    
    NSString *question = _question;
    
    RecentSearchAnswer *rsa =  _datasource[indexPath.row];
    _selectedSectionNUmber =  rsa.sectionSequenceId;
    
    NSString *requestURLString = [NSString stringWithFormat:@"%@%@%@",kBaseUrl,kAskAQuestionAPI,question];
    
    requestURLString =[requestURLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];

    
    [[GCFAPIClient instance] postService:requestURLString
                              parameters:nil
                                    type:@"GET"
                                 handler:^(NSURLResponse *urlResponse, id responseObject, NSError *error) {
        if(error) {
            [self performSelectorOnMainThread:@selector(showErrorAlert:) withObject:error.description waitUntilDone:NO];
        }else {
            NSLog(@"%@", responseObject);
            [self performSelectorInBackground:@selector(parseAnswers:) withObject:responseObject];
        }
    }];
    
}

-(void)showErrorAlert:(NSString *)errorDescription {
//    [self showErrorAlertWithTitle:@"Oops!" andDesription:errorDescription];
    [self showErrorAlertWithTitle:kERROR_TECHNICAL_TITLE andDesription:kERROR_TECHNICAL_DESCRIPTION];

}

-(void)parseAnswers:(id)responseObject {
    NSArray *answers =     [[DataManager sharedManager] parseAnswersResponse:responseObject];
    NSArray *array = [answers filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(Answer *a, NSDictionary *bindings) {
        return [a.sectionNumber isEqualToString:_selectedSectionNUmber];
    }]];
    
    
    if (array.count == 0) {
        //no element matched... load search screen 
        [self performSelectorOnMainThread:@selector(loadSearchScreen:) withObject:answers waitUntilDone:NO];
    }
    else {
        //show hyperlink...
        Answer * a = array.firstObject;
        [self performSelectorOnMainThread:@selector(showRecentSectionScreen:) withObject:a waitUntilDone:NO];
        
    }

    
}






@end
