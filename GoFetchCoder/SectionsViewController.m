//
//  SectionsViewController.m
//  GoFetchCoder
//
//  Created by Guest on 1/19/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "SectionsViewController.h"
#import "CustomCell.h"
#import "Answer.h"
#import "NSString_stripHTML.h"
#import "DataManager.h"
#import "RecentSearchQuestionsVC.h"
#import "UITextView+GFCAdditions.h"
#import "Constants.h"
#import "ChapterViewController.h"
#import "BookmarkVC.h"
#import "AppDelegate.h"
#import "UIColor+GFCAdditions.h"
#import "LogoCell.h"
#import "UIColor+GFCAdditions.h"
#import "UIFont+GFCAdditions.h"
#import "LocationViewController.h"
#import <Mixpanel/Mixpanel.h>


@interface SectionsViewController ()<UITextViewDelegate,
                                     UITableViewDataSource,
                                     UITableViewDelegate>{
    UITapGestureRecognizer *tap;

                                         
}

@property (weak, nonatomic) IBOutlet UITextView *txtView;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UITableView *table;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingView;
@property (nonatomic, copy)NSMutableArray *datasource;
@property (weak, nonatomic) IBOutlet UIButton *btnLocation;
- (IBAction)btnLocationAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *dimView;



@end

@implementation SectionsViewController


-(void)dimScreen:(BOOL)shouldDim {
//    _table.alpha = shouldDim ? 0.3 : 1.0;
    _dimView.hidden = !shouldDim;

}

-(void)shouldShowLoadingIndicator:(BOOL)shouldShow {
    [self dimScreen:NO];

    if (shouldShow) {
        [self dimScreen:YES];
        self.loadingView.hidden = NO;
        [self.loadingView startAnimating];
    }
    else {
        [self dimScreen:NO];
        self.loadingView.hidden = YES;
        [self.loadingView stopAnimating];
        
    }
}






-(void)runInBackground:(NSString *)string {
    
    NSDictionary *dict = [[DataManager sharedManager] getAnswersForQuestion:_txtView.text];
    NSArray *array = [[DataManager sharedManager] parseAnswersResponse:dict];
    
    [self performSelectorOnMainThread:@selector(loadSearchScreen:) withObject:array waitUntilDone:NO];
}

-(void)loadSearchScreen:(NSArray *)array {
    
    [self shouldShowLoadingIndicator:NO];
    
    _datasource = [NSMutableArray arrayWithArray:array];
    [_datasource addObject:@"IBMLogo"];

    [_table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}



- (IBAction)btnSearchAction:(id)sender {
    
    if (!_txtView.text.length) {
        return;
    }
    [_txtView resignFirstResponder];
    

    
    [self shouldShowLoadingIndicator:YES];
    
    [self performSelectorInBackground:@selector(runInBackground:) withObject:_txtView.text];

    
}





-(void)setup{

    [_table setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
           action:@selector(tapDetected)];
    
//Setup UI
    _txtView.textColor = [UIColor colorFromHex:@"#123752"];
    _txtView.font = [UIFont fontWithName:@"Lato-Regular" size:16];

//        _table.estimatedRowHeight = 20;
//        _table.rowHeight = UITableViewAutomaticDimension;


    [self.table registerNib:[UINib nibWithNibName:@"LogoCell"
                                           bundle:[NSBundle mainBundle]]
     forCellReuseIdentifier:@"LogoCell"];
    
    
    [self.table registerNib:[UINib nibWithNibName:@"CustomCell"
                                           bundle:[NSBundle mainBundle]]
     forCellReuseIdentifier:@"CustomCell"];
    
    
    
}

-(void)tapDetected {
    [self.view endEditing:YES];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setViewLocationButton];
    [_table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
    _txtView.text = _searchQuestion;
    [_txtView sizeFontToFit:_txtView.text minSize:10 maxSize:18];
    _datasource = [NSMutableArray arrayWithArray:_answersArray];
    [_datasource addObject:@"IBMLogo"];
    

}


- (void)keyboardWillHide
{
//    [_table removeGestureRecognizer:tap];
    [_dimView removeGestureRecognizer:tap];

}

- (void)keyboardWillShow
{
//    [_table addGestureRecognizer:tap];
    [_dimView addGestureRecognizer:tap];
    
}


- (void)dismissKeyboard {
    [self.view endEditing:YES];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
    
   
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)setViewLocationButton{
    
    [self.btnLocation setTitle:@"South San Francisco" forState:UIControlStateNormal];
    self.btnLocation.titleLabel.font = [UIFont smallTextFieldFont];
    [self.btnLocation.titleLabel setTextAlignment:UITextAlignmentLeft];
    
    [self.btnLocation setImage: [UIImage imageNamed:@"i_shevron"] forState:UIControlStateNormal];
    [self.btnLocation setTintColor:[UIColor editColor]];
    
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
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 60;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Answer *a = _datasource[indexPath.row];
    
    if (a.hyperlink && a.sectionName && a.sectionNumber) {
        ChapterViewController *chapterVC = [[ChapterViewController alloc] initWithNibName:NSStringFromClass([ChapterViewController class]) bundle:nil];
        
        chapterVC.hyperlink            = a.hyperlink;
        chapterVC.chapterNo             =a.chapterNo;
        chapterVC.sectionSequenceId    = a.sectionNumber;
        chapterVC.sectionSequenceTitle = a.sectionName;
        chapterVC.sectionAnswer = a.answer;
        
    
        chapterVC.searchQuestion = _txtView.text;
        
        [self shouldShowLoadingIndicator:NO];
        
    
        
        [self.navigationController pushViewController:chapterVC animated:YES];
        
    }
    else {
        [self showErrorAlertWithTitle:kERROR_TECHNICAL_TITLE andDesription:kERROR_TECHNICAL_DESCRIPTION];

        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CustomCell";
    static NSString *LogoCellIdentifier = @"LogoCell";
    
    if (indexPath.row +1  == _datasource.count) {
        UITableViewCell *logoCell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:LogoCellIdentifier];
        return logoCell;
    }
    
    
    CustomCell *cell = (CustomCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
//        cell = [nib objectAtIndex:0];
//    }
    
   
    
    
    Answer *a = _datasource[indexPath.row];
    
    cell.labelSectionNumber.text = [NSString stringWithFormat:@"%@ %@",a.sectionNumber != nil ? a.sectionNumber:@"",a.sectionName != nil ? a.sectionName:@""] ;
    cell.labelBestMatch.text     = a.confidence == kMaxConfidence ? @"Best Match" : @"";
    
    cell.labelAnswer.text =a.snip;
//    a.snip
//    cell.labelAnswer.attributedText = [[NSAttributedString alloc] initWithString:a.answer];
//    cell.txtView.text = a.answer;
   
    return cell;
}



#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self dimScreen:YES];

}
- (void)textViewDidEndEditing:(UITextView *)textView {
    [self dimScreen:NO];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    [textView sizeFontToFit:textView.text minSize:kMinimumFontSize maxSize:kMaximumFontSize];

    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        [self performSelector:@selector(btnSearchAction:) withObject:nil afterDelay:0.5];
        
        return NO;
    }

    
    return YES;
}

- (IBAction)btnLocationAction:(id)sender {
    
 
    
    LocationViewController *locationVC = [[LocationViewController alloc] init];
    [self.navigationController pushViewController:locationVC animated:YES];
}



    


@end
