//
//  LocationViewController.m
//  GoFetchCoder
//
//  Created by Sandro Albert on 3/19/16.
//  Copyright © 2016 Nitin gupta. All rights reserved.
//

#import "LocationViewController.h"
#import "TreeViewNode.h"
#import "TheProjectCell.h"
#import "UIFont+GFCAdditions.h"
#import "UIColor+GFCAdditions.h"

@interface LocationViewController ()
{
    NSUInteger indentation;
    NSMutableArray *nodes;
    NSMutableArray * casheNodes;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end



@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(expandCollapseNode:) name:@"ProjectTreeNodeButtonClicked" object:nil];
    
    [self fillNodesArray];
    [self fillDisplayArray];
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super viewDidUnload];
    
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:nil];
    
//    self.searchBar.layer.cornerRadius  = 6;
//    self.searchBar.clipsToBounds       = YES;
//    self.searchBar.barTintColor = [UIColor whiteColor];
//    self.searchBar.layer.borderWidth = 2;
    
    
}


#pragma mark - Messages to fill the tree nodes and the display array

//This function is used to expand and collapse the node as a response to the ProjectTreeNodeButtonClicked notification
- (void)expandCollapseNode:(NSNotification *)notification
{
    [self fillDisplayArray];
    [self.tableView reloadData];
}

//These two functions are used to fill the nodes array with the tree nodes
- (void)fillNodesArray
{
    TreeViewNode *firstLevelNode1 = [[TreeViewNode alloc]init];
    firstLevelNode1.nodeLevel = 0;
    firstLevelNode1.nodeObject = [NSString stringWithFormat:@"Parent node 1"];
    firstLevelNode1.isExpanded = YES;
    firstLevelNode1.nodeChildren = [[self fillChildrenForNode] mutableCopy];
    
    TreeViewNode *firstLevelNode2 = [[TreeViewNode alloc]init];
    firstLevelNode2.nodeLevel = 0;
    firstLevelNode2.nodeObject = [NSString stringWithFormat:@"Parent node 2"];
    firstLevelNode2.isExpanded = YES;
    firstLevelNode2.nodeChildren = [[self fillChildrenForNode] mutableCopy];
    
    TreeViewNode *firstLevelNode3 = [[TreeViewNode alloc]init];
    firstLevelNode3.nodeLevel = 0;
    firstLevelNode3.nodeObject = [NSString stringWithFormat:@"Parent node 3"];
    firstLevelNode3.isExpanded = YES;
    firstLevelNode3.nodeChildren = [[self fillChildrenForNode] mutableCopy];
    
    TreeViewNode *firstLevelNode4 = [[TreeViewNode alloc]init];
    firstLevelNode4.nodeLevel = 0;
    firstLevelNode4.nodeObject = [NSString stringWithFormat:@"Parent node 4"];
    firstLevelNode4.isExpanded = YES;
    firstLevelNode4.nodeChildren = [[self fillChildrenForNode] mutableCopy];
    
     casheNodes = [NSMutableArray arrayWithObjects:firstLevelNode1, firstLevelNode2, firstLevelNode3, firstLevelNode4, nil];
    
    // for searhing.
     nodes = casheNodes;
    
}

- (NSArray *)fillChildrenForNode
{
    TreeViewNode *secondLevelNode1 = [[TreeViewNode alloc]init];
    secondLevelNode1.nodeLevel = 1;
    secondLevelNode1.nodeObject = [NSString stringWithFormat:@"Child node 1"];
    
    TreeViewNode *secondLevelNode2 = [[TreeViewNode alloc]init];
    secondLevelNode2.nodeLevel = 1;
    secondLevelNode2.nodeObject = [NSString stringWithFormat:@"Child node 2"];
    
    TreeViewNode *secondLevelNode3 = [[TreeViewNode alloc]init];
    secondLevelNode3.nodeLevel = 1;
    secondLevelNode3.nodeObject = [NSString stringWithFormat:@"Child node 3"];
    
    TreeViewNode *secondLevelNode4 = [[TreeViewNode alloc]init];
    secondLevelNode4.nodeLevel = 1;
    secondLevelNode4.nodeObject = [NSString stringWithFormat:@"Child node 4"];
    
    NSMutableArray *childrenArray = [NSMutableArray arrayWithObjects:secondLevelNode1, secondLevelNode2, secondLevelNode3, secondLevelNode4, nil];
    
    return childrenArray;
}

//This function is used to fill the array that is actually displayed on the table view
- (void)fillDisplayArray
{
    self.displayArray = [[NSMutableArray alloc]init];
    for (TreeViewNode *node in nodes) {
        [self.displayArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}

//This function is used to add the children of the expanded node to the display array
- (void)fillNodeWithChildrenArray:(NSArray *)childrenArray
{
    for (TreeViewNode *node in childrenArray) {
        [self.displayArray addObject:node];
        if (node.isExpanded) {
            [self fillNodeWithChildrenArray:node.nodeChildren];
        }
    }
}

//These functions are used to expand and collapse all the nodes just connect them to two buttons and they will work
- (IBAction)expandAll:(id)sender
{
    [self fillNodesArray];
    [self fillDisplayArray];
    [self.tableView reloadData];
}

- (IBAction)collapseAll:(id)sender
{
    for (TreeViewNode *treeNode in nodes) {
        treeNode.isExpanded = NO;
    }
    [self fillDisplayArray];
    [self.tableView reloadData];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.displayArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //It's cruical here that this identifier is treeNodeCell and that the cell identifier in the story board is anything else but not treeNodeCell
    static NSString *CellIdentifier = @"treeNodeCell";
    UINib *nib = [UINib nibWithNibName:@"ProjectCell" bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
    
    TheProjectCell *cell = (TheProjectCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    TreeViewNode *node = [self.displayArray objectAtIndex:indexPath.row];
    cell.treeNode = node;
    
    cell.cellLabel.text = node.nodeObject;
    cell.cellLabel.font = [UIFont inputTextFieldFont];
    cell.cellLabel.textColor = [UIColor editColor];
    
    if (node.isExpanded) {
        [cell setTheButtonBackgroundImage:[UIImage imageNamed:@"i_arrow_down"]];
    }
    else {
        [cell setTheButtonBackgroundImage:[UIImage imageNamed:@"i_arrow_right"]];
    }
    [cell setNeedsDisplay];
    
    
    // Configure the cell...
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
   
    nodes = [[NSMutableArray alloc] init];// remove all data that belongs to previous search
    
    if (searchText.length == 0) {
        nodes = casheNodes;
        [self fillDisplayArray];
        [self.tableView reloadData];
        
    }

    
    if([searchText isEqualToString:@""]  && searchText==nil){
        [self.tableView reloadData];
        return;
    }
    
    
    for(TreeViewNode *cashNode in casheNodes)
    {
        TreeViewNode *node = [[TreeViewNode alloc] init];
        node.nodeChildren = [[NSMutableArray alloc] init];
        NSInteger counter = 0;
        Boolean isRegisteredNode = false;
        NSRange pr = [cashNode.nodeObject rangeOfString:searchText];
        if (pr.location != NSNotFound) {
            node.nodeObject = cashNode.nodeObject;
            [nodes addObject:node];
            isRegisteredNode = true;
            
        }
        
        for(TreeViewNode *childNode in cashNode.nodeChildren){
            
            NSRange r = [childNode.nodeObject rangeOfString:searchText];
            if(r.location != NSNotFound)
            {
                counter ++;
                [node.nodeChildren addObject:childNode];
            
            }
        }
        
        if (counter != 0) {
            node.nodeObject = cashNode.nodeObject;
            if (!isRegisteredNode) {
                [nodes addObject:node];
                isRegisteredNode = false;
            }
            
            counter = 0;
        }
    }
    
    
    [self fillDisplayArray];
    [self.tableView reloadData];
}


@end



