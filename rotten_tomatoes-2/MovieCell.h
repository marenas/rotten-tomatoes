//
//  MovieCell.h
//  rotten_tomatoes-2
//
//  Created by Matias Arenas Sepulveda on 10/24/15.
//  Copyright © 2015 Matias Arenas Sepulveda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;

@end
