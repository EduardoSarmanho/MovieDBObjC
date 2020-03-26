//
//  Functions.m
//  TheMovieDBObjc
//
//  Created by Eduardo Sarmanho on 26/03/20.
//  Copyright © 2020 Eduardo Sarmanho. All rights reserved.
//

#import "Functions.h"
#import "Movie.h"

@implementation Functions


- (void) fetchNowPlayingMovies: andCompletionHandler:(void (^)(NSMutableArray<Movie *>* result)) completionHandler {
    NSMutableArray<Movie *> *movies = NSMutableArray.new;
    
    NSLog(@"Fetching now movies...");
    NSString *urlString = @"https://api.themoviedb.org/3/movie/now_playing?api_key=ca01e6658836c07edbe8b8ce2ac738c1&language=pt-BR&page=1";
    NSURL *url = [NSURL URLWithString:urlString];
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSError *err;
        NSArray *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        if (err){
            NSLog(@"Failed to serialize into JSON: %@", err);
            return;
        }
        
        NSDictionary *queryDictionary = [results valueForKey:@"results"];
        
        for (NSDictionary *movieList in queryDictionary) {
            NSString *title = movieList[@"title"];
            NSString *overview = movieList[@"overview"];
            NSNumber *rating = movieList[@"vote_average"];
            NSString *posterPath = movieList[@"poster_path"];
            NSNumber *identifier = movieList[@"id"];
            
            Movie *movie = Movie.new;
            movie.title = title;
            movie.overview = overview;
            movie.posterPath = posterPath;
            movie.rating = rating;
            movie.identifier = identifier;
            
            [movies addObject:movie];
        }
        
        NSLog(@"Finished fetching now playing movies!");
         completionHandler(movies);
    }] resume];
}

    - (void) fetchPopularMovies: andCompletionHandler:(void (^)(NSMutableArray<Movie *>* result)) completionHandler {
        NSLog(@"Fetching popular movies...");
        
        NSString *urlString = @"https://api.themoviedb.org/3/movie/popular?api_key=ca01e6658836c07edbe8b8ce2ac738c1&language=pt-BR&page=1";
        NSURL *url = [NSURL URLWithString:urlString];
        
        [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            
            NSError *err;
            NSArray *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
            if (err){
                NSLog(@"Failed to serialize into JSON: %@", err);
                return;
            }
            
            NSDictionary *queryDictionary = [results valueForKey:@"results"];
            NSMutableArray<Movie *> *movies = NSMutableArray.new;
            
            for (NSDictionary *movieList in queryDictionary) {
                NSString *title = movieList[@"title"];
                NSString *overview = movieList[@"overview"];
                NSNumber *rating = movieList[@"vote_average"];
                NSString *posterPath = movieList[@"poster_path"];
                NSNumber *identifier = movieList[@"id"];
                
                Movie *movie = Movie.new;
                movie.title = title;
                movie.overview = overview;
                movie.posterPath = posterPath;
                movie.rating = rating;
                movie.identifier = identifier;
                
                [movies addObject:movie];
            }
            NSLog(@"Finished fetching popular movies!");
            completionHandler(movies);
        }] resume];
    }

- (void) fetchSearchMovies: (NSString *) name : andCompletionHandler:(void (^)(NSMutableArray<Movie *>* result)) completionHandler {
    dispatch_async(dispatch_get_global_queue(0,0), ^{

    NSLog(@"Fetching searched string...");
    
    NSMutableArray<Movie *> *searchedMovies = NSMutableArray.new;
    
    NSString *urlString = @"https://api.themoviedb.org/3/search/movie?api_key=ca01e6658836c07edbe8b8ce2ac738c1&language=pt-BR&query=";
    NSString *urlString2 = @"&page=1&include_adult=false";
    urlString = [urlString stringByAppendingString: name];
    urlString = [urlString stringByAppendingString:urlString2];
    
    NSURL *url = [NSURL URLWithString:urlString];
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSError *err;
        NSArray *results = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&err];
        if (err){
            NSLog(@"Failed to serialize into JSON: %@", err);
            return;
        }
        
        NSDictionary *resultDictionary = [results valueForKey: @"results"];
        for (NSDictionary *movieList in resultDictionary) {
            NSString *title = movieList[@"title"];
            NSString *overview = movieList[@"overview"];
            NSNumber *rating = movieList[@"vote_average"];
            NSString *posterPath = @"";
            if(![movieList[@"poster_path"] isEqual: [NSNull null]]){
                posterPath = movieList[@"poster_path"];
            }
            NSNumber *identifier = movieList[@"id"];
            
            Movie *movie = Movie.new;
            movie.title = title;
            movie.overview = overview;
            movie.posterPath = posterPath;
            movie.rating = rating;
            movie.identifier = identifier;
            
            [searchedMovies addObject:movie];
        }
        
        NSLog(@"Finished fecthing searched string!");
        completionHandler(searchedMovies);
    }] resume];
    });
}
@end
