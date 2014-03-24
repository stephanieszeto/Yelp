//
//  PlacesViewController.m
//  Yelp
//
//  Created by Stephanie Szeto on 3/20/14.
//  Copyright (c) 2014 projects. All rights reserved.
//

#import "PlacesViewController.h"
#import "FilterViewController.h"
#import "Place.h"
#import "PlaceCell.h"
#import "YelpClient.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface PlacesViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *places;
@property (nonatomic, strong) YelpClient *client;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSString *searchTerm;
@property (nonatomic, strong) NSArray *filterInputs;

@end

@implementation PlacesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // assign table view's delegate, data source
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    // add filter button to navigation bar
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStyleBordered target:self action:@selector(onFilterClick)];
    
    // add search bar to navigation bar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 250, 40)];
    self.searchBar.delegate = self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBar];
    
    // load place cell
    UINib *placeCellNib = [UINib nibWithNibName:@"PlaceCell" bundle:nil];
    [self.tableView registerNib:placeCellNib forCellReuseIdentifier:@"PlaceCell"];
    
    self.places = [[NSMutableArray alloc] init];
    self.searchTerm = @"Brunch";
    [self fetchData:self.searchTerm];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

# pragma mark - Private methods

- (void)fetchData:(NSString *)input {
    if (!self.filterInputs) {
        [self.client searchWithTerm:input success:^(AFHTTPRequestOperation *operation, id response) {            
            [self.places removeAllObjects];
            NSArray *businesses = [response objectForKey:@"businesses"];
            
            for (NSDictionary *business in businesses) {
                Place *place = [[Place alloc] initWithDictionary:business];
                [self.places addObject:place];
            }
            [self.tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", [error description]);
        }];
    
        [self.tableView reloadData];
        
    } else {
        // extract deal input
        NSNumber *deals = self.filterInputs[0];
    
        // extract distance input
        NSNumber *distance = self.filterInputs[1];
    
        // extract sort input
        NSNumber *sort = self.filterInputs[2];
        
        // extract category input
        NSNumber *category = self.filterInputs[3];

        NSArray *inputs = [[NSArray alloc] initWithObjects:input, deals, distance, sort, category, nil];
        
        [self.client searchWithInputs:inputs success:^(AFHTTPRequestOperation *operation, id response) {
            // remove previous filters
            self.filterInputs = nil;
            
            [self.places removeAllObjects];
            NSArray *businesses = [response objectForKey:@"businesses"];
        
            for (NSDictionary *business in businesses) {
                Place *place = [[Place alloc] initWithDictionary:business];
                [self.places addObject:place];
            }
            
            for (Place *place in self.places) {
                NSLog(@"place name: %@", place.name);
            }
            
            [self.tableView reloadData];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", [error description]);
        }];
        
        [self.tableView reloadData];
    }
}

- (void)addItemViewController:(FilterViewController *)controller didFinishEnteringItems:(NSArray *)inputs {
    NSLog(@"sent over these inputs: %@", inputs);
    self.filterInputs = inputs;
    [self fetchData:self.searchTerm];
}

# pragma mark - Navigation bar methods

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"%@", searchText);
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    NSLog(@"done editing");
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    UITextField *searchBarText;
    
    for (UIView *subview in searchBar.subviews){
        for (UIView *subSubview in subview.subviews){
            if ([subSubview isKindOfClass:[UITextField class]]) {
                searchBarText = (UITextField *)subSubview;
                break;
            }
        }
    }
    
    [searchBar resignFirstResponder];
    self.searchTerm = searchBarText.text;
    [self fetchData:self.searchTerm];
}

- (void)onFilterClick {
    FilterViewController *fvc = [[FilterViewController alloc] init];
    fvc.delegate = self;
    [self.navigationController pushViewController:fvc animated:YES];
}

# pragma mark - Table view methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.places.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PlaceCell *placeCell = [tableView dequeueReusableCellWithIdentifier:@"PlaceCell" forIndexPath:indexPath];
    Place *place = self.places[indexPath.row];
    
    //NSLog(@"place/cell: %@", place.name);
    [placeCell setPlace:place];
    return placeCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end