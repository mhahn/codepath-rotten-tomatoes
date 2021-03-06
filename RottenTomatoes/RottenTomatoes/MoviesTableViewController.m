//
//  MoviesViewController.m
//  RottenTomatoes
//
//  Created by mhahn on 6/9/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import "AFNetworking.h"
#import "ProgressHUD.h"

#import "MoviesTableViewController.h"
#import "Movie.h"
#import "MovieTableViewCell.h"
#import "MovieViewController.h"


@interface MoviesTableViewController () {
    UIView *networkErrorView;
    UILabel *networkErrorLabel;
    NSArray *movies;
}

- (void)handleConnectionError:(NSError *)error;
- (void)fetchData:(id)sender;
- (void)finishFetching:(id)sender;

@end

@implementation MoviesTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Movies";
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure the refresh control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(fetchData:) forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:refreshControl];
    
    // Trigger the initial fetch of data
    [ProgressHUD show:@"Loading..."];
    [self fetchData:nil];
    
    // Configure table cells
    self.tableView.rowHeight = 175;
    self.tableView.dataSource = self;
    UINib *movieCellNib = [UINib nibWithNibName:@"MovieTableViewCell" bundle:nil];
    [self.tableView registerNib:movieCellNib forCellReuseIdentifier:@"MovieCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    
    // XXX return the height here instead of setting a static height in viewDidLoad
    cell.movie = movies[indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    cell.movie = movies[indexPath.row];
    MovieViewController *mvc = [[MovieViewController alloc]initWithNibName:@"MovieViewController" bundle:nil backgroundImage:[cell getCurrentThumbnailImage]];
    
    // Pass the selected object to the new view controller.
    mvc.movie = movies[indexPath.row];
    
    // Push the view controller.
    [self.navigationController pushViewController:mvc animated:YES];
}

#pragma mark - Private Methods

- (void)handleConnectionError:(NSError *)error {
    
    NSError *underlyingError = [[error userInfo] objectForKey:NSUnderlyingErrorKey];
    
    // configure the error view
    networkErrorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
    networkErrorView.backgroundColor = [UIColor blackColor];
    networkErrorView.alpha = .85;
    
    // configure the error label
    networkErrorLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
    networkErrorLabel.text = [underlyingError localizedDescription];
    [networkErrorLabel setTextColor:[UIColor whiteColor]];
    [networkErrorLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12.0f]];
    [networkErrorLabel setTextAlignment:NSTextAlignmentCenter];
    
    [networkErrorView addSubview:networkErrorLabel];
    [self.view addSubview:networkErrorView];

}

- (void)finishFetching:(id)sender {
    [ProgressHUD dismiss];
    if (sender) {
        [(UIRefreshControl *)sender endRefreshing];
    }
}

- (void)fetchData:(id)sender {
    NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5.0];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // cleanup any previous network error]
        if ([networkErrorView isDescendantOfView:self.view]) {
            [networkErrorView removeFromSuperview];
        }
        
        movies = [Movie moviesFromArrayOfDictionaries:responseObject[@"movies"]];
        [self.tableView reloadData];
        [self finishFetching:sender];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self handleConnectionError:error];
        [self finishFetching:sender];
    }];
    
    [operation start];
}

@end
