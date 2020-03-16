//
//  ViewController.m
//  TheMovieDBObjc
//
//  Created by Eduardo Sarmanho on 16/03/20.
//  Copyright © 2020 Eduardo Sarmanho. All rights reserved.
//

#import "ViewController.h"
#import "Movie.h"
#import "APIAnswer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self fetchMoviesUsingJSON];
    // Do any additional setup after loading the view.
}

- (void) fetchMoviesUsingJSON {
    NSLog(@"Fetching Movies...");
    
    NSString *urlString = @"https://api.themoviedb.org/3/discover/movie?api_key=ca01e6658836c07edbe8b8ce2ac738c1&language=pt-BR&sort_by=popularity.desc&include_adult=false&include_video=false&page=1";
    NSURL *url = [NSURL URLWithString:urlString];
    
    [[NSURLSession.sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"Finished fetching courses!");
        
//        NSString *dummyString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//        NSLog(@"Dummy string%@", dummyString);
        
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
            NSString *description = movieList[@"overview"];
            NSNumber *rate = movieList[@"vote_average"];
            NSString *imageURL = movieList[@"poster_path"];
//            NSString *category = movieList[@""]
            
            
            Movie *movie = Movie.new;
            movie.title = title;
            movie.overview = description;
            movie.resume = description;
            movie.imageURL = imageURL;
            movie.rate = rate;
//            movie.category = category;

            [movies addObject:movie];
        }
        NSLog(@"%@", movies);
        
        
    }] resume];
}


@end
