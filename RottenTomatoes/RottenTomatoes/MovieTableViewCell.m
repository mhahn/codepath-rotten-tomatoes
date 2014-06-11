//
//  MovieCellView.m
//  RottenTomatoes
//
//  Created by mhahn on 6/9/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import "MovieTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface MovieTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *movieThumbnailImage;
@property (weak, nonatomic) IBOutlet UILabel *movieTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *movieSynopsisLabel;

@end

@implementation MovieTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

# pragma mark - Public Methods

- (void)setMovie:(Movie *)movie {
    _movie = movie;
    self.movieTitleLabel.text = movie.title;
    self.movieSynopsisLabel.text = movie.synopsis;
    
    // copied from AFNetworking so we can configure success animation
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:movie.posters[@"detailed"]]];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    [self.movieThumbnailImage setImageWithURLRequest:request placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        self.movieThumbnailImage.alpha = 0.0;
        self.movieThumbnailImage.image = image;
        [UIView animateWithDuration:0.5 animations:^{
            self.movieThumbnailImage.alpha = 1.0;
        }];
    } failure:nil];
    
}


@end
