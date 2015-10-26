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

    // Do any additional setup after loading the view.
    self.movieTitle.text = self.movieDetail[@"title"];
    self.synopsis.text = self.movieDetail[@"synopsis"];
    [self.synopsis sizeToFit];
    NSDictionary *posters = self.movieDetail[@"posters"];
    NSString *posterUrlString = posters[@"detailed"];

    [self.posterView setImageWithURL:[NSURL URLWithString:posterUrlString]];
    
    NSRange range = [posterUrlString rangeOfString:@".*cloudfront.net/" options:NSRegularExpressionSearch];
    NSString *newUrlString = [posterUrlString stringByReplacingCharactersInRange:range withString:@"https://content6.flixster.com/"];

    // use the low res poster image immediately and fetch the high res one
    [self.posterView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:newUrlString]] placeholderImage:self.posterView.image success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.posterView.image = image;
    } failure:nil];
    
    // set scroll view
    CGRect newBackgroundViewFrame = self.contentView.frame;
    newBackgroundViewFrame.size.height = self.synopsis.frame.origin.y + self.synopsis.frame.size.height + 20;
    self.contentView.frame = newBackgroundViewFrame;
    
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, self.contentView.frame.origin.y + self.contentView.frame.size.height)];
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
