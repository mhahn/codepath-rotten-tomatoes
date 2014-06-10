//
//  MoviesViewController.m
//  RottenTomatoes
//
//  Created by mhahn on 6/9/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import "ProgressHUD.h"

#import "MoviesTableViewController.h"
#import "Movie.h"
#import "MovieTableViewCell.h"
#import "MovieViewController.h"


@interface MoviesTableViewController () {
    UIView *networkErrorView;
    UILabel *networkErrorLabel;
}

- (void)handleConnectionError:(NSError *)error;

@end

@implementation MoviesTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Movies";

        NSString *url = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=g9au4hv6khv6wzvzgt55gpqs";
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (connectionError) {
                [self handleConnectionError:connectionError];
            } else {
                self.movies = [Movie moviesFromJSON:data error:nil];
                [self.tableView reloadData];
            }
            [ProgressHUD dismiss];
            
        }];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [ProgressHUD show:@"Loading..."];
    self.tableView.rowHeight = 150;
    self.tableView.dataSource = self;
    UINib *movieCellNib = [UINib nibWithNibName:@"MovieTableViewCell" bundle:nil];
    [self.tableView registerNib:movieCellNib forCellReuseIdentifier:@"MovieCell"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    
    // XXX return the height here instead of setting a static height in viewDidLoad
    cell.movie = self.movies[indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MovieViewController *mvc = [[MovieViewController alloc]initWithNibName:@"MovieViewController" bundle:nil];
    
    // Pass the selected object to the new view controller.
    mvc.movie = self.movies[indexPath.row];
    
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


@end
