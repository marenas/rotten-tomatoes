//
//  MovieDetailsViewController.m
//  rotten_tomatoes-2
//
//  Created by Matias Arenas Sepulveda on 10/24/15.
//  Copyright © 2015 Matias Arenas Sepulveda. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailsViewController ()

@end

@implementation MovieDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width,self.scrollView.frame.size.height * 3)];
    
    // Do any additional setup after loading the view.
    self.movieTitle.text = self.movieDetail[@"title"];
    self.synopsis.text = self.movieDetail[@"synopsis"];
    [self.synopsis sizeToFit];
    NSDictionary *posters = self.movieDetail[@"posters"];
    NSString *posterUrlString = posters[@"detailed"];
    [self.posterView setImageWithURL:[NSURL URLWithString:posterUrlString]];
    
    NSRange range = [posterUrlString rangeOfString:@".*cloudfront.net/" options:NSRegularExpressionSearch];
    NSString *newUrlString = [posterUrlString stringByReplacingCharactersInRange:range withString:@"https://content6.flixster.com/"];
    [self.posterView setImageWithURL:[NSURL URLWithString:newUrlString]];
    
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
