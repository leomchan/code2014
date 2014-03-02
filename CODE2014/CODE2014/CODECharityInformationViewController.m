//
//  CODECharityInformationViewController.m
//  CODE2014
//
//  Created by Allan Chu on 2014-03-01.
//  Copyright (c) 2014 Nobis Studios. All rights reserved.
//

#import "CODECharityInformationViewController.h"
#import "CODEDataManager.h"

@interface CODECharityInformationViewController ()
@property (nonatomic, strong) NSArray *arrayOfBusinesses;
@end

@implementation CODECharityInformationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.arrayOfBusinesses = [NSArray array];
    
    [[CODEDataManager manager] getApplicableTransactionsForCountry:self.selectedCountry withBlock:^(NSArray *items, NSError *error) {
        NSMutableSet *set = [NSMutableSet set];
        for (PFObject *object in items){
            [set addObject:object[@"BN"]];
        }
        
        [[CODEDataManager manager] getCharitiesByBusinessNumber:[set allObjects] withBlock:^(NSArray *items, NSError *error) {
            self.arrayOfBusinesses = items;
            [self.mainTableView reloadData];
        }];
        
    }];
    
	// Do any additional setup after loading the view.
}

- (void) didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayOfBusinesses count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TEST"];
    PFObject *object = [self.arrayOfBusinesses objectAtIndex:indexPath.row];
    NSString *string = object[@"Account_Name"];
    tableViewCell.textLabel.text = [string capitalizedString];
    
    return tableViewCell;
}
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
@end
