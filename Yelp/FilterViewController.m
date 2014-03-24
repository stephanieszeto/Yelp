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
#import "PickerFilterCell.h"

@interface FilterViewController ()

@property (nonatomic, weak) IBOutlet UITableView *filterTableView;
@property (nonatomic) NSInteger sortIndex;
@property (nonatomic) NSInteger distanceIndex;
@property (nonatomic, strong) ToggleFilterCell *tc;

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

    // set up picker filter cell
    UINib *pickerFilterNib = [UINib nibWithNibName:@"PickerFilterCell" bundle:nil];
    [self.filterTableView registerNib:pickerFilterNib forCellReuseIdentifier:@"PickerFilterCell"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Private methods

- (void)onSearchClick {    
    NSNumber *off = [NSNumber numberWithInteger:self.tc.off];
    NSNumber *distanceIndex = [NSNumber numberWithInteger:self.distanceIndex];
    NSNumber *sortIndex = [NSNumber numberWithInteger:self.sortIndex];
    NSArray *inputs = [[NSArray alloc] initWithObjects: off, distanceIndex, sortIndex, nil];
    [self.delegate addItemViewController:self didFinishEnteringItems:inputs];
    [self.navigationController popToRootViewControllerAnimated:TRUE];
}

# pragma mark - Table view methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 43;
    } else {
        return 120;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ToggleFilterCell *tfc = [self.filterTableView dequeueReusableCellWithIdentifier:@"ToggleFilterCell"];
        tfc.filterName.text = @"Offering a Deal";
        self.tc = tfc;
        return tfc;
    } else {
        PickerFilterCell *pfc = [self.filterTableView dequeueReusableCellWithIdentifier:@"PickerFilterCell"];
        pfc.picker.delegate = self;
        pfc.picker.dataSource = self;
        
        if (indexPath.section == 1) {
            pfc.picker.tag = 1;
        } else if (indexPath.section == 2) {
            pfc.picker.tag = 2;
        }
        
        return pfc;
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

# pragma mark - Picker methods

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    if (row == 0) {
        if (pickerView.tag == 1) {
            title = @"100 meters";
        } else if (pickerView.tag == 2) {
            title = @"Best Match";
        }
    } else if (row == 1) {
        if (pickerView.tag == 1) {
            title = @"200 meters";
        } else if (pickerView.tag == 2) {
            title = @"Distance";
        }
    } else if (row == 2) {
        if (pickerView.tag == 1) {
            title = @"300 meters";
        } else if (pickerView.tag == 2) {
            title = @"Highest Rated";
        }
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView.tag == 1) {
        self.distanceIndex = row;
        NSLog(@"set distance to be %d", row);
    } else if (pickerView.tag == 2) {
        self.sortIndex = row;
        NSLog(@"set sort to be %d", row);
    }
}

@end
