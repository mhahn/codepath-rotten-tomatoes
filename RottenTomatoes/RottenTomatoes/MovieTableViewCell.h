//
//  MovieCellView.h
//  RottenTomatoes
//
//  Created by mhahn on 6/9/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

@interface MovieTableViewCell : UITableViewCell

@property (weak, nonatomic) Movie *movie;
- (UIImage *)getCurrentThumbnailImage;

@end
