//
//  BookmarkVC.m
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 1/23/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "BookmarkVC.h"
#import "CustomCell.h"
#import "Bookmark.h"
#import "Constants.h"
//#import "NGNavigationBarMenu.h"
#import "AppDelegate.h"
#import "GetBookmarksOperation.h"
#import "UIColor+GFCAdditions.h"

#import "ChapterViewController.h"
#import "BookmarkSectionViewController.h"
#import "RemoveBookmarkOperation.h"

#import "BookmarkCell.h"

@interface BookmarkVC ()<UITableViewDataSource,UITableViewDelegate>{
    NSIndexPath *currentIndexPath;
    Bookmark *currentBookmark;
    
     __block BOOL isSortAscending;
}

@property (weak, nonatomic) IBOutlet UITableView *table;
@property (nonatomic, strong)NSMutableArray *datasource;
@property (weak, nonatomic) IBOutlet UIView *noBookmarksView;
@property (weak, nonatomic) IBOutlet UIImageView *imgSort;

//@property (strong, nonatomic) NGNavigationBarMenu *menu;

@end

@implementation BookmarkVC

#pragma mark - Remove Bookmark - 

-(void)removeBookmark:(NSInteger)bookmarkId
{
    AppDelegate *appDelegate = kAppDelegate;
    
    RemoveBookmarkOperation *removeBookmarkOperation = [[RemoveBookmarkOperation alloc] init];
    removeBookmarkOperation.bookmarkId         = bookmarkId;
    removeBookmarkOperation.onCompletion = ^(NSString *responseString, BOOL isSuccess) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isSuccess) {
                if (_datasource.count) {
                    [self hideEmptyScreen];
                }
                else {
                    [self showEmptyScreen];
                }
                //     [self showErrorAlertWithTitle:@"Bookmark Removed Successfully" andDesription:@""];
            }
            else {
                [self showErrorAlertWithTitle:kERROR_TECHNICAL_TITLE andDesription:kERROR_TECHNICAL_DESCRIPTION];
                
                [_datasource insertObject:currentBookmark atIndex:currentIndexPath.row];
                [_table insertRowsAtIndexPaths:@[currentIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                
                
                
            }
            
        });
        
    };
    [appDelegate.queue addOperation:removeBookmarkOperation];
}



#pragma UItableview delegate & Datasource -
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"Remove";
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        currentBookmark = [_datasource[indexPath.row] copy];
        currentIndexPath = indexPath;
        
        [_datasource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
        [self removeBookmark:currentBookmark.bookmarkId];
        
    } else {
        NSLog(@"Unhandled editing style! %ld", (long)editingStyle);
    }
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datasource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"BookmarkCell";
    UINib *nib = [UINib nibWithNibName:@"BookmarkCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    BookmarkCell *cell = (BookmarkCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Bookmark *b                       = _datasource[indexPath.row];
    cell.labelSectionId.text          = b.sectionSequenceId;
    cell.labelSectionDescription.text = b.sectionSequenceTitle;
    
    cell.labelSectionDescription.font = [UIFont fontWithName:@"Lato-Regular" size:17.0];
    cell.lblDate.font = [UIFont fontWithName:@"Lato-Regular" size:13.0];
    cell.labelSectionId.font = [UIFont fontWithName:@"Lato-Regular" size:13.0];
    cell.labelSectionDescription.textColor = [UIColor editColor];
    cell.lblDate.textColor = [UIColor inputTextFieldColor];
    cell.labelSectionId.textColor = [UIColor inputTextFieldColor];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    cell.lblDate.text                 = [dateFormatter stringFromDate:b.updatedDate];

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Bookmark *b = _datasource[indexPath.row];
    
    if (b.hyperlink) {
        
        BookmarkSectionViewController *VC = [[BookmarkSectionViewController alloc] initWithNibName:NSStringFromClass([BookmarkSectionViewController class]) bundle:nil];
        
        VC.hyperlink            = b.hyperlink;
        VC.sectionSequenceId    = b.sectionSequenceId;
        VC.sectionSequenceTitle = b.sectionSequenceTitle;
        VC.isBookmarked         = YES;
        VC.bookmarkId           = b.bookmarkId;
        
        
        [self.navigationController pushViewController:VC animated:YES];
        
    }
    else {
        [self showErrorAlertWithTitle:kERROR_TECHNICAL_TITLE andDesription:kERROR_TECHNICAL_DESCRIPTION];
        
    }
}


//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    static NSString *CellIdentifier = @"TableviewCell";
//    
//    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        cell.textLabel.numberOfLines = 0;
//        cell.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//        cell.textLabel.font          = [UIFont fontWithName:@"Lato-Regular" size:13.0];
//        cell.textLabel.textColor     = [UIColor colorFromHex:@"#123752"];
//        
//        cell.detailTextLabel.font          = [UIFont fontWithName:@"Lato-Regular" size:16.0];
//        cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        cell.detailTextLabel.numberOfLines = 0;
//        cell.detailTextLabel.adjustsLetterSpacingToFitWidth = YES;
//        cell.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//        cell.detailTextLabel.textColor     = [UIColor colorFromHex:@"#123752"];
//    }
//    
//    Bookmark *b               = _datasource[indexPath.row];
//    
//    cell.textLabel.text       = b.sectionSequenceId;
//    cell.detailTextLabel.text = b.sectionSequenceTitle;
//    
//    [cell.textLabel sizeToFit];
//
//    [cell.detailTextLabel sizeToFit];
//
//    
//    
//    
//    return cell;
//
//
//}


#pragma mark - View Controller Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = kBookmarks;
     isSortAscending = NO;
    
    if (isSortAscending) {
        self.imgSort.image = [UIImage imageNamed:@"i_reverse_shevron"];
    } else {
        self.imgSort.image = [UIImage imageNamed:@"i_shevron"];
        
    }
    _table.estimatedRowHeight = 100;
    _table.rowHeight = UITableViewAutomaticDimension;

     [self hideEmptyScreen];
   
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    isSortAscending = NO;

    if (isSortAscending) {
        self.imgSort.image = [UIImage imageNamed:@"i_reverse_shevron"];
    } else {
        self.imgSort.image = [UIImage imageNamed:@"i_shevron"];
        
    }
    AppDelegate *appDelegate = kAppDelegate;
    
    GetBookmarksOperation *bookmarksOperation = [[GetBookmarksOperation alloc] init];
    
    bookmarksOperation.onSuccess = ^(NSArray *bookmarks) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bookmarks.count) {
                [self hideEmptyScreen];
                _datasource = [NSMutableArray arrayWithArray:bookmarks];
//                [_table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                [_table reloadData];
            }
            else {
                //show Empty screen.
                [self showEmptyScreen];
            }
        });
    };
    
    bookmarksOperation.onFailure = ^(NSDictionary *failureDict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showErrorAlertWithTitle:kERROR_TECHNICAL_TITLE andDesription:kERROR_TECHNICAL_DESCRIPTION];
        });
 
    };
    
    [appDelegate.queue addOperation:bookmarksOperation];
    
}

-(void)showEmptyScreen
{
    _noBookmarksView.hidden = NO;
    
}


-(void)hideEmptyScreen
{
    _noBookmarksView.hidden = YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)btnSortAction:(id)sender {
    
    isSortAscending = !isSortAscending;
    if (isSortAscending) {
        self.imgSort.image = [UIImage imageNamed:@"i_reverse_shevron"];
    } else {
        self.imgSort.image = [UIImage imageNamed:@"i_shevron"];
        
    }
    NSArray *sortedArray;
    sortedArray = [_datasource sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(Bookmark *)a updatedDate];
        NSDate *second = [(Bookmark *)b updatedDate];
        return  isSortAscending ? [first compare:second] : [second compare:first];
    }];
    
    _datasource = [sortedArray copy];
    //    [_table reloadData];
    [_table reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}
@end
