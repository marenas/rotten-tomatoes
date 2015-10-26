//
//  MoviesViewController.m
//  rotten_tomatoes-2
//
//  Created by Matias Arenas Sepulveda on 10/24/15.
//  Copyright © 2015 Matias Arenas Sepulveda. All rights reserved.
//

#import "MoviesViewController.h"
#import "MovieCell.h"
#import "MovieDetailsViewController.h"

#import "SVProgressHUD.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"

@interface MoviesViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *networkErrorView;
@property (weak, nonatomic) IBOutlet UILabel *networkErrorLabel;

@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, assign) MoviesViewControllerType type;

- (void)handleConnectionError:(NSError *)error;
- (void)fetchData:(id)sender;
- (void)finishFetching:(id)sender;

@end

@implementation MoviesViewController

- (id)initWithType:(MoviesViewControllerType)type {

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self = [storyboard instantiateViewControllerWithIdentifier:@"MoviesViewController"];
    
    self.type = type;
    switch (self.type) {
        case MoviesViewControllerTypeBoxOffice:
            self.title = @"Theater Movies";
            break;
        case MoviesViewControllerTypeDvd:
            self.title = @"DVD Movies";
            break;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    UITableViewController *tableViewController = [[UITableViewController alloc] init];
    tableViewController.tableView = self.tableView;

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(fetchData:) forControlEvents:UIControlEventValueChanged];
    tableViewController.refreshControl = refreshControl;
    
    [self.tabBarController.tabBar setHidden:NO];
    //get data
    [SVProgressHUD showWithStatus:@"Loading..."];
    [self fetchData:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.movies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell" forIndexPath:indexPath];
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    cell.movieTitleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"synopsis"];
    
    NSDictionary *posters = movie[@"posters"];
    NSString *posterUrlString = posters[@"detailed"];
    [cell.posterView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:posterUrlString]] placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        // fade in the image
        cell.posterView.image = image;
        cell.posterView.alpha = 0.0;
        [UIView animateWithDuration:0.5 animations:^{
            cell.posterView.alpha = 1.0;
        }];
    } failure:nil];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showDetailView"]) {
        MovieDetailsViewController *movieDetailsViewController = (MovieDetailsViewController*)segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *movieDetail = [[NSDictionary alloc] initWithDictionary:self.movies[indexPath.row]];
        movieDetailsViewController.movieDetail = movieDetail;
        movieDetailsViewController.hidesBottomBarWhenPushed = YES;
    }
}

- (void)handleConnectionError:(NSError *)error {
    
    NSError *underlyingError = [[error userInfo] objectForKey:NSUnderlyingErrorKey];
    self.networkErrorLabel.text = [underlyingError localizedDescription];
    self.networkErrorView.hidden = false;
    CGRect newFrame = self.networkErrorView.frame;
    newFrame.size.height = 44;
    [self.networkErrorView setFrame:newFrame];
}

- (void)finishFetching:(id)sender {
    [SVProgressHUD dismiss];
    if (sender) {
        [(UIRefreshControl *)sender endRefreshing];
    }
}

- (void)fetchData:(id)sender {

    NSString *urlString;
    switch (self.type) {
        case MoviesViewControllerTypeBoxOffice:
            urlString = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=ws32mxpd653h5c8zqfvksxw9";
            break;
        case MoviesViewControllerTypeDvd:
            urlString = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=ws32mxpd653h5c8zqfvksxw9";
            break;
        default:
            // this shouldn't happen
            NSAssert(false, @"Invalid type %ld", self.type);
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5.0];
    
    //        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:5.0];
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"Sucessful request");
        NSLog(@"%@", responseObject);
        //cleanup any previous network error
        self.networkErrorView.hidden = true;
        CGRect newFrame = self.networkErrorView.frame;
        newFrame.size.height = 0;
        [self.networkErrorView setFrame:newFrame];
        
        self.movies = responseObject[@"movies"];
        [self.tableView reloadData];
        [self finishFetching:sender];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILED request");
        [self handleConnectionError:error];
        [self finishFetching:sender];
    }];
    
    [operation start];
}

@end
