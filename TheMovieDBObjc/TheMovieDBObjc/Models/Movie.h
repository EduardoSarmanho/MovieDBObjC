//
//  Movie.h
//  TheMovieDBObjc
//
//  Created by Gustavo Travassos on 16/03/20.
//  Copyright © 2020 Eduardo Sarmanho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Genre.h"

NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *overview;
@property (strong, nonatomic) NSNumber *rating;
@property (strong, nonatomic) NSString *category;
@property (strong, nonatomic) NSString *posterPath;
@property (strong, nonatomic) NSNumber *identifier;
@property (strong, nonatomic) NSMutableArray<Genre *> *genres;

@end

NS_ASSUME_NONNULL_END
