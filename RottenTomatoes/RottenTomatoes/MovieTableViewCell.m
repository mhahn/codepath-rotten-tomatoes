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
    [self.movieThumbnailImage setImageWithURL:[NSURL URLWithString:movie.posters[@"detailed"]]];
}


@end
