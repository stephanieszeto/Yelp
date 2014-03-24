//
//  FilterViewController.m
//  Yelp
//
//  Created by Stephanie Szeto on 3/20/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "FilterViewController.h"
#import "PlacesViewController.h"
#import "ToggleFilterCell.h"
#import "ExpandFilterCell.h"

@interface FilterViewController ()

@property (nonatomic, weak) IBOutlet UITableView *filterTableView;
@property (nonatomic) NSInteger sortIndex;
@property (nonatomic) NSInteger distanceIndex;
@property (nonatomic) NSInteger categoryIndex;
@property (nonatomic, strong) ToggleFilterCell *tc;

@property (nonatomic, assign) BOOL distanceExpanded;
@property (nonatomic, assign) BOOL sortExpanded;
@property (nonatomic, assign) BOOL categoryExpanded;

@property (nonatomic, strong) NSString *chosenDistance;
@property (nonatomic, strong) NSString *chosenSort;
@property (nonatomic, strong) NSString *chosenCategory;

@property (nonatomic, strong) NSArray *options;

@end

@implementation FilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Filter";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // assign table view's data source, delegate
    self.filterTableView.delegate = self;
    self.filterTableView.dataSource = self;
    
    // create search button in navigation bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleBordered target:self action:@selector(onSearchClick)];
    
    // set up toggle filter cell
    UINib *toggleFilterNib = [UINib nibWithNibName:@"ToggleFilterCell" bundle:nil];
    [self.filterTableView registerNib:toggleFilterNib forCellReuseIdentifier:@"ToggleFilterCell"];
    
    // set up expand filter cell
    UINib *expandFilterNib = [UINib nibWithNibName:@"ExpandFilterCell" bundle:nil];
    [self.filterTableView registerNib:expandFilterNib forCellReuseIdentifier:@"ExpandFilterCell"];

    // set up option arrays
    NSArray *distanceOptions = [[NSArray alloc] initWithObjects:@"100 meters", @"200 meters", @"300 meters", nil];
    NSArray *sortOptions = [[NSArray alloc] initWithObjects:@"Best Match", @"Distance", @"Highest Rated", nil];
    NSArray *categoryOptions = [[NSArray alloc] initWithObjects:@"Breakfast & Brunch", @"Comfort Food", @"Dim Sum", @"Fondue", @"Raw Food", @"Tapas Bars", nil];
    self.options = [[NSArray alloc] initWithObjects:distanceOptions, distanceOptions, sortOptions, categoryOptions, nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Private methods

- (void)onSearchClick {
    // clear values
    self.chosenDistance = nil;
    self.chosenSort = nil;
    self.chosenDistance = nil;
    
    // create, send inputs
    NSNumber *off = [NSNumber numberWithInteger:self.tc.off];
    NSNumber *distanceIndex = [NSNumber numberWithInteger:self.distanceIndex];
    NSNumber *sortIndex = [NSNumber numberWithInteger:self.sortIndex];
    NSNumber *categoryIndex = [NSNumber numberWithInteger:self.categoryIndex];
    NSArray *inputs = [[NSArray alloc] initWithObjects: off, distanceIndex, sortIndex, categoryIndex, nil];
    [self.delegate addItemViewController:self didFinishEnteringItems:inputs];
    
    // return back to places view controller
    [self.navigationController popToRootViewControllerAnimated:TRUE];
}

# pragma mark - Table view methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 43;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.distanceExpanded && section == 1) {
        return 3;
    } else if (self.sortExpanded && section == 2) {
        return 3;
    } else if (!self.categoryExpanded && section == 3 && !self.chosenCategory) {
        return 2;
    } else if (self.categoryExpanded && section == 3) {
        return 6;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ToggleFilterCell *tfc = [self.filterTableView dequeueReusableCellWithIdentifier:@"ToggleFilterCell"];
        tfc.filterName.text = @"Offering a Deal";
        self.tc = tfc;
        return tfc;
    } else {
         ExpandFilterCell *efc = [self.filterTableView dequeueReusableCellWithIdentifier:@"ExpandFilterCell"];
        NSInteger section = indexPath.section;
        NSInteger row = indexPath.row;
        NSString *text;
        if (section == 1) {
            if (self.chosenDistance != nil && !self.distanceExpanded) {
                text = self.chosenDistance;
            } else {
                text = self.options[section][row];
            }
        } else if (section == 2) {
            if (self.chosenSort != nil && !self.sortExpanded) {
                text = self.chosenSort;
            } else {
                text = self.options[section][row];
            }
        } else if (section == 3) {
            if (self.chosenCategory != nil && !self.categoryExpanded) {
                text = self.chosenCategory;
            } else if (!self.categoryExpanded && row == 1) {
                text = @"See All";
            } else {
                text = self.options[section][row];
            }
        }
        efc.option.text = text;
        return efc;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title;
    if (section == 0) {
        title = @"Most Popular";
    } else if (section == 1) {
        title = @"Distance";
    } else if (section == 2) {
        title = @"Sort by";
    } else if (section == 3) {
        title = @"Category";
    }
    return title;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    NSInteger section = indexPath.section;
    if (section == 1) {
        self.distanceExpanded = !self.distanceExpanded;
        self.distanceIndex = row;
        self.chosenDistance = self.options[section][row];
        NSLog(@"set distance to be %@", self.chosenDistance);
    } else if (section == 2) {
        self.sortExpanded = !self.sortExpanded;
        self.sortIndex = row;
        self.chosenSort = self.options[section][row];
        NSLog(@"set sort to be %@", self.chosenSort);
    } else if (section == 3) {
        self.categoryIndex = row;
        self.chosenCategory = self.options[section][row];
        self.categoryExpanded = !self.categoryExpanded;
        NSLog(@"set category to be %@", self.chosenCategory);
    }
    [self.filterTableView reloadData];
}

@end
