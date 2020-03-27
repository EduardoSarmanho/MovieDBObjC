//
//  Functions.h
//  TheMovieDBObjc
//
//  Created by Eduardo Sarmanho on 26/03/20.
//  Copyright © 2020 Eduardo Sarmanho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"
NS_ASSUME_NONNULL_BEGIN

@interface Functions : NSObject
- (void) fetchNowPlayingMovies: andCompletionHandler:(void (^)(NSMutableArray<Movie *>* result)) completionHandle;
- (void) fetchSearchMovies: (NSString *) name : andCompletionHandler:(void (^)(NSMutableArray<Movie *>* result)) completionHandler;
- (void) fetchPopularMovies: andCompletionHandler:(void (^)(NSMutableArray<Movie *>* result)) completionHandler;

@end

NS_ASSUME_NONNULL_END
