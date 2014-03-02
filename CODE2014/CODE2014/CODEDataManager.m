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

- (void) getCharityPersonnel:(PFObject *) selectedBusiness withBlock:(CODEDataRetrievalBlock) block {
    PFQuery *query = [PFQuery queryWithClassName:@"dir"];
    [query setLimit:1000];
    [query whereKey:@"BN" equalTo:selectedBusiness[@"BN"]];
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    [query findObjectsInBackgroundWithBlock:block];
    
}
- (void) getBusinessFinancialNumbers:(PFObject *) selectedBusiness withBlock:(CODEDataRetrievalBlock) block {
    PFQuery *query = [PFQuery queryWithClassName:@"Fin"];
    [query setLimit:1000];
    [query whereKey:@"BN" equalTo:selectedBusiness[@"BN"]];
    [query orderByAscending:@"englishName"];
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    [query findObjectsInBackgroundWithBlock:block];
    
}

- (void) getApplicableCountriesWithBlock:(CODEDataRetrievalBlock) block{
    PFQuery *query = [PFQuery queryWithClassName:@"CountryInfo"];
    [query setLimit:1000];
    [query orderByAscending:@"englishName"];
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    [self findAllObjectsWithQuery:query withBlock:block];
}

- (void) getApplicableTransactionsForCountry:(PFObject *) selectedCountry withBlock:(CODEDataRetrievalBlock) block{
    
    PFQuery *query = [PFQuery queryWithClassName:@"Country"];
    [query setLimit:1000];
    [query whereKey:@"Country" equalTo:selectedCountry[@"countryCode"]];
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    [query findObjectsInBackgroundWithBlock:block];
}

- (void) getCharitiesByBusinessNumber:(NSArray *) arrayOfBNs withBlock:(CODEDataRetrievalBlock) block{
    PFQuery *query = [PFQuery queryWithClassName:@"Ident"];
    [query setLimit:1000];
    [query orderByAscending:@"Account_Name"];
    [query whereKey:@"BN" containedIn:arrayOfBNs];
    [query setCachePolicy:kPFCachePolicyNetworkOnly];
    [query findObjectsInBackgroundWithBlock:block];

    
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
                
                PFQuery *query = [PFQuery queryWithClassName:@"CountryInfo"];
                [query setSkip:skip];
                [query orderByAscending:@"englishName"];
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
