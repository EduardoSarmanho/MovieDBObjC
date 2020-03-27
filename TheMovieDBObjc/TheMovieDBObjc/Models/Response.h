//
//  Response.h
//  TheMovieDBObjc
//
//  Created by Gustavo Travassos on 24/03/20.
//  Copyright © 2020 Eduardo Sarmanho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Movie.h"


NS_ASSUME_NONNULL_BEGIN

@interface Response : NSObject

@property (strong, nonatomic) NSMutableArray<Movie *> *movies;
@property (strong, nonatomic) NSMutableArray<Genre *> *genres;

@end

NS_ASSUME_NONNULL_END
