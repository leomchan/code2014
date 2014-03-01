//
//  CODEDataManager.m
//  CODE2014
//
//  Created by Allan Chu on 2014-03-01.
//  Copyright (c) 2014 Nobis Studios. All rights reserved.
//

#import "CODEDataManager.h"

@interface CODEDataManager()
@property (nonatomic, strong) NSMutableArray *arrayOfCountries;
@end

@implementation CODEDataManager

static CODEDataManager *manager = nil;

+ (CODEDataManager *)manager
{
    if (manager)
        return manager;
    
    @synchronized(self) {
        if (manager)
            return manager;
        
        manager = [[CODEDataManager alloc] init];
        manager.arrayOfCountries = [NSMutableArray array];
    }
    
    return manager;
}

- (void) getApplicableCountriesWithBlock:(CODEDataRetrievalBlock) block{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Country"];
    [query whereKeyExists:@"Country_Name_Eng"];
    [query setLimit:1000];
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    [self findAllObjectsWithQuery:query withBlock:block];
}

- (void)findAllObjectsWithQuery:(PFQuery *)query withBlock:(void (^)(NSArray *objects, NSError *error))block
{
    
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            
            [self.arrayOfCountries addObjectsFromArray:objects];
            // The find succeeded. Add the returned objects to allObjects
            CODEDebugLog(@"%lu", (unsigned long)[self.arrayOfCountries count]);
            if (objects.count == 1000) {
                // There might be more objects in the table. Update the skip value and execute the query again.
                NSInteger skip = [query skip];
                skip+= 1000;
                
                PFQuery *query = [PFQuery queryWithClassName:@"Country"];
                [query whereKeyExists:@"Country_Name_Eng"];
                [query setSkip:skip];
                [query setLimit:1000];
                // Go get more results
                [self findAllObjectsWithQuery:query withBlock:block];
            }
            else
            {
                // We are done so return the objects
                block(self.arrayOfCountries, nil);
            }
            
        }
        else
        {
            block(nil,error);
        }
    }];
    
    
}


@end
