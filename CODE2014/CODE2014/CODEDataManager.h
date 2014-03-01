//
//  CODEDataManager.h
//  CODE2014
//
//  Created by Allan Chu on 2014-03-01.
//  Copyright (c) 2014 Nobis Studios. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CODEDataRetrievalBlock)(NSArray *items, NSError *error);


@interface CODEDataManager : NSObject

+ (CODEDataManager *) manager;

- (void) getApplicableCountriesWithBlock:(CODEDataRetrievalBlock) block;

@end
