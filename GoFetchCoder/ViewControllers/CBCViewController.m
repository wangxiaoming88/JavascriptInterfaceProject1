//
//  CBCViewController.m
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 1/26/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "CBCViewController.h"
#import "Constants.h"



#define kSectionHeight 50


@interface CBCViewController ()
@property (weak, nonatomic) IBOutlet UITableView *table;


@property (nonatomic, strong) NSArray             *datasource;
@property (nonatomic, strong) NSArray             *sectionTitleArray;
@property (nonatomic, strong) NSMutableDictionary *sectionContentDict;
@property (nonatomic, strong) NSMutableArray      *arrayForBool;


@end

@implementation CBCViewController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = kCBC;

//    UITapGestureRecognizer* doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapTable:)];
//    doubleTap.numberOfTapsRequired = 2;
//    doubleTap.numberOfTouchesRequired = 1;
//    [_table addGestureRecognizer:doubleTap];
//    
    
    // Do any additional setup after loading the view from its nib.
    if (!_sectionTitleArray) {
        _sectionTitleArray = [[NSMutableArray alloc] init];
        NSMutableArray *array  = [NSMutableArray array];
        for (int i=2; i<=34; i++) {
            [array addObject:[NSString stringWithFormat:@"Chapter %d",i]];
        }
        
        _sectionTitleArray = [NSArray arrayWithArray:array];
    
    }
    if (!_arrayForBool) {
        NSMutableArray *array  = [NSMutableArray array];
        for (int i=0; i<=35; i++) {
            [array addObject:[NSNumber numberWithBool:NO]];
        }
        
        _arrayForBool = array;
        
    }
    if (!_sectionContentDict) {
        _sectionContentDict  = [[NSMutableDictionary alloc] init];
        
        [_sectionTitleArray enumerateObjectsUsingBlock:^(NSString *sectionTitle, NSUInteger idx, BOOL * _Nonnull stop) {
            NSArray *array1     = [NSArray arrayWithObjects:@"Text 1", @"Text 2", @"Text 3", @"Text 4",@"Text 5", nil];
            [_sectionContentDict setValue:array1 forKey:sectionTitle];
        }];
        
        
    }

    
}

/*
-(void)doubleTapTable:(UISwipeGestureRecognizer*)tap
{
    if (UIGestureRecognizerStateEnded == tap.state)
    {
        CGPoint p = [tap locationInView:tap.view];
        
        NSIndexPath* indexPath = [_table indexPathForRowAtPoint:p];
        
        if(indexPath){  // user taped a cell
            
            // whatever you want to do if user taped cell
            
        } else { // otherwise check if section header was clicked
            
            NSUInteger i;
            
            for(i=0;i<[_table numberOfSections];i++) {
                
                CGRect headerViewRect = [_table rectForHeaderInSection:i];
                
                BOOL isInside = CGRectContainsPoint (headerViewRect,
                                                     p);
                if(isInside) {
                    
                    // handle Header View Selection
                    
                    break;
                }
                
            }
        }
        
    }
}
 */

#pragma mark - Table View



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_sectionTitleArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return kSectionHeight;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([[_arrayForBool objectAtIndex:section] boolValue]) {
        return [[_sectionContentDict valueForKey:[_sectionTitleArray objectAtIndex:section]] count];
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView              = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kSectionHeight)];
    headerView.tag                  = section;
    headerView.backgroundColor      = [UIColor grayColor];
    UILabel *headerString           = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20-50, kSectionHeight)];
    BOOL manyCells                  = [[_arrayForBool objectAtIndex:section] boolValue];
//    if (!manyCells) {
//        headerString.text = @"click to enlarge";
//    }else{
//        headerString.text = @"click again to reduce";
//    }
    headerString.text = _sectionTitleArray[section];
    headerString.textAlignment      = NSTextAlignmentLeft;
    headerString.textColor          = [UIColor blackColor];
    [headerView addSubview:headerString];
    
    UITapGestureRecognizer  *headerTapped   = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderTapped:)];
    [headerView addGestureRecognizer:headerTapped];
    
    //up or down arrow depending on the bool
    UIImageView *upDownArrow        = [[UIImageView alloc] initWithImage:manyCells ? [UIImage imageNamed:@"upArrowBlack"] : [UIImage imageNamed:@"downArrowBlack"]];
    upDownArrow.autoresizingMask    = UIViewAutoresizingFlexibleLeftMargin;
    upDownArrow.frame               = CGRectMake(self.view.frame.size.width-40, 10, 30, 30);
    [headerView addSubview:upDownArrow];
    
    return headerView;
}
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *footer  = [[UIView alloc] initWithFrame:CGRectZero];
//    return footer;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([[_arrayForBool objectAtIndex:indexPath.section] boolValue]) {
        return kSectionHeight;
    }
    return 1;
}
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    BOOL manyCells  = [[_arrayForBool objectAtIndex:indexPath.section] boolValue];
    if (!manyCells) {
        cell.textLabel.text = @"click to enlarge";
    }
    else{
        NSArray *content = [_sectionContentDict valueForKey:[_sectionTitleArray objectAtIndex:indexPath.section]];
        cell.textLabel.text = [content objectAtIndex:indexPath.row];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_table deselectRowAtIndexPath:indexPath animated:YES];

    
    //    DetailViewController *dvc;
//    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
//        dvc = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPhone"  bundle:[NSBundle mainBundle]];
//    }else{
//        dvc = [[DetailViewController alloc] initWithNibName:@"DetailViewController_iPad"  bundle:[NSBundle mainBundle]];
//    }
//    dvc.title        = [sectionTitleArray objectAtIndex:indexPath.section];
//    dvc.detailItem   = [[sectionContentDict valueForKey:[sectionTitleArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
//    [self.navigationController pushViewController:dvc animated:YES];
    
}


#pragma mark - gesture tapped
- (void)sectionHeaderTapped:(UITapGestureRecognizer *)gestureRecognizer{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:gestureRecognizer.view.tag];
    if (indexPath.row == 0) {
        BOOL collapsed  = [[_arrayForBool objectAtIndex:indexPath.section] boolValue];
        collapsed       = !collapsed;
        [_arrayForBool replaceObjectAtIndex:indexPath.section withObject:[NSNumber numberWithBool:collapsed]];
        
        //reload specific section animated
        NSRange range   = NSMakeRange(indexPath.section, 1);
        NSIndexSet *sectionToReload = [NSIndexSet indexSetWithIndexesInRange:range];
        [_table reloadSections:sectionToReload withRowAnimation:UITableViewRowAnimationFade];
    }
}



@end
