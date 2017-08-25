//
//  BrowseCodesVC.m
//  GoFetchCoder
//
//  Created by Abhishek Bedi on 2/27/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "BrowseCodesVC.h"
#import "UIColor+GFCAdditions.h"
#import "BrowseCodesDetailVC.h"

#import "Constants.h"
#import "BookmarkCell.h"


@interface BrowseCodesVC ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong)NSMutableArray *datasource;
@property (nonatomic, strong)NSMutableArray *arrDescription;


@property (weak, nonatomic) IBOutlet UITableView *table;

@end



@implementation BrowseCodesVC


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datasource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BrowseCodesDetailVC *vc = [[BrowseCodesDetailVC alloc] initWithNibName:NSStringFromClass([BrowseCodesDetailVC class]) bundle:nil];
    
    NSString *chapterNumber = [NSString stringWithFormat:@"chapter%02ld",indexPath.row + 2];
    
    
    NSString *hyperlink = [NSString stringWithFormat:@"%@cbc/%@.html",kBaseUrl,chapterNumber];
    
    //[NSString stringWithFormat:@"%02d", indexPath.row +1 ];
    vc.hyperlink = hyperlink;
    vc.screenTitle = _datasource[indexPath.row];
    
    
    [self.navigationController pushViewController:vc animated:YES];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"BookmarkCell";
    
    BookmarkCell *cell = (BookmarkCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"BookmarkCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.labelSectionId.text          = _datasource[indexPath.row];
    cell.labelSectionDescription.text = [_arrDescription[indexPath.row] capitalizedString];
    
    return cell;
    
}



/*- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"BrowseCodesCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
//        cell.textLabel.numberOfLines = 0;
//        cell.textLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16.0];
        cell.textLabel.textColor = [UIColor colorFromHex:@"#123752"];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];

        
    }
    
    cell.textLabel.text       = _datasource[indexPath.row];
    cell.detailTextLabel.text = [_arrDescription[indexPath.row] capitalizedString];

    return cell;
    
}*/


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if (!_datasource) {
        _datasource = [[NSMutableArray alloc] init];
        NSMutableArray *array  = [NSMutableArray array];
        for (int i=2; i<=34; i++) {
            [array addObject:[NSString stringWithFormat:@"Chapter %d",i]];
        }
        
        _datasource = [NSMutableArray arrayWithArray:array];
        
        _arrDescription = [[NSMutableArray alloc] initWithObjects:
                           @"DEFINITIONS",
                           @"USE AND OCCUPANCY CLASSIFICATION",
                           @"SPECIAL DETAILED REQUIREMENTS BASED ON USE AND OCCUPANCY",
                           @"GENERAL BUILDING HEIGHTS AND AREAS",
                           @"TYPES OF CONSTRUCTION",
                           @"FIRE AND SMOKE PROTECTION FEATURES",
                           @"INTERIOR FINISHES",
                           @"FIRE PROTECTION SYSTEMS",
                           @"MEANS OF EGRESS",
                           @"RESERVED",
                           @"INTERIOR ENVIRONMENT",
                           @"ENERGY EFFICIENCY",
                           @"EXTERIOR WALLS",
                           @"ROOF ASSEMBLIES AND ROOFTOP STRUCTURES",
                           @"STRUCTURAL DESIGN",
                           @"STRUCTURAL TESTS AND SPECIAL INSPECTIONS",
                           @"SOILS AND FOUNDATIONS",
                           @"CONCRETE",
                           @"ALUMINUM",
                           @"MASONRY",
                           @"STEEL",
                           @"WOOD",
                           @"GLASS AND GLAZING",
                           @"GYPSUM BOARD AND PLASTER",
                           @"PLASTIC",
                           @"ELECTRICAL",
                           @"MECHANICAL SYSTEMS",
                           @"PLUMBING SYSTEMS",
                           @"ELEVATORS AND CONVEYING SYSTEMS",
                           @"SPECIAL CONSTRUCTION",
                           @"ENCROACHMENTS INTO THE PUBLIC RIGHT-OF-WAY",
                           @"SAFEGUARDS DURING CONSTRUCTION",
                           @"EXISTING STRUCTURES",
                           nil];
        
    }
    
    _table.estimatedRowHeight = 100;
    _table.rowHeight = UITableViewAutomaticDimension;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
