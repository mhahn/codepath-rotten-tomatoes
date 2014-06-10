//
//  Movie.m
//  RottenTomatoes
//
//  Created by mhahn on 6/9/14.
//  Copyright (c) 2014 Michael Hahn. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (id)initWithMovieData:(NSDictionary *)movieData {
    self = [super init];
    if (self) {
        _movieId = movieData[@"id"];
        _title = movieData[@"title"];
        _synopsis = movieData[@"synopsis"];
        _posters = movieData[@"posters"];
    }
    return self;
}

// XXX is this __autoreleasing neccessary?
+ (NSArray *)moviesFromJSON:(NSData *)moviesJSON error:(NSError *__autoreleasing *)error {
    id object = [NSJSONSerialization JSONObjectWithData:moviesJSON options:0 error:nil];

    NSArray *movies = [NSArray array];
    for (NSDictionary *movieData in object[@"movies"]) {
        Movie *movie = [[Movie alloc] initWithMovieData:movieData];
        movies = [movies arrayByAddingObject:movie];
    }
    return movies;
}

@end
