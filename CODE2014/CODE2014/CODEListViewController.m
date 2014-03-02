//
//  CODEViewController.m
//  CODE2014
//
//  Created by Allan Chu on 2014-02-28.
//  Copyright (c) 2014 Nobis Studios. All rights reserved.
//

#import "CODEListViewController.h"
#import "CODEDataManager.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import "MBProgressHUD.h"

@interface CODEListViewController ()
@property (nonatomic, strong) NSMutableArray *arrayOfCountries;

@property (nonatomic, strong) CLPlacemark *selectedPlacemark;
@end

@implementation CODEListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.arrayOfCountries  = [NSMutableArray array];
    [[CODEDataManager manager] getApplicableCountriesWithBlock:^(NSArray *items, NSError *error) {
        
        for (PFObject *object in items){
            PFGeoPoint *geoPoint = object[@"location"];
            if (geoPoint != nil){
                [self.arrayOfCountries addObject:object];
            }
        }
        [self.mainTableView reloadData];
       // self.arrayOfCountries = [[set allObjects] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    }];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayOfCountries count];
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TEST"];
    PFObject *object = [self.arrayOfCountries objectAtIndex:indexPath.row];
    NSString *string = @"";
    if (object[@"englishName"] != nil){
       string = object[@"englishName"];
    }else {
        string = object[@"countryCode"];
    }
    tableViewCell.textLabel.font = [UIFont fontWithName:@"AmericanTypewriter" size:14];
    tableViewCell.textLabel.text = [string capitalizedString];
    return tableViewCell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *object = [self.arrayOfCountries objectAtIndex:indexPath.row];
    [self.delegate listViewController:self didSelectCountryInfo:object];
    [self.navigationController popToRootViewControllerAnimated:YES];
}


@end
