//
//  Movie.h
//  RottenTomatoes
//
//  Created by mhahn on 6/9/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Movie : NSObject

@property (nonatomic) NSString *movieId;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *synopsis;
@property (nonatomic) NSDictionary *posters;

- (id)initWithMovieData:(NSDictionary *)movieData;
+ (NSArray *)moviesFromJSON:(NSData *)moviesJSON error:(NSError **)error;

@end
