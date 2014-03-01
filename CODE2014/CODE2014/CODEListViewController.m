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
#import "CODEMapViewController.h"
#import <AddressBook/AddressBook.h>

@interface CODEListViewController ()
@property (nonatomic, strong) NSArray *arrayOfCountries;

@property (nonatomic, strong) CLPlacemark *selectedPlacemark;
@end

@implementation CODEListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.arrayOfCountries  = [NSArray array];
    [[CODEDataManager manager] getApplicableCountriesWithBlock:^(NSArray *items, NSError *error) {
        
        self.arrayOfCountries = items;
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
    NSString *string = object[@"englishName"];
    tableViewCell.textLabel.text = string;
    return tableViewCell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"CODEPushToMap"]){
        CODEMapViewController *controller = segue.destinationViewController;
        controller.selectedPlacemark = self.selectedPlacemark;
    }
}

@end
