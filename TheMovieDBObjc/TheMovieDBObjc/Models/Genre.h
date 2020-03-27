//
//  Genre.h
//  TheMovieDBObjc
//
//  Created by Gustavo Travassos on 19/03/20.
//  Copyright © 2020 Eduardo Sarmanho. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Genre : NSObject

@property (nonatomic, strong) NSNumber *identifier;
@property (strong, nonatomic) NSString *name;

@end

NS_ASSUME_NONNULL_END
