//
//  CODEPieChartInfoViewController.m
//  CODE2014
//
//  Created by Allan Chu on 2014-03-01.
//  Copyright (c) 2014 Nobis Studios. All rights reserved.
//

#import "CODEPieChartInfoViewController.h"
#import "CODEPieChart.h"

@interface CODEPieChartTableViewCell: UITableViewCell
- (void) configureCell;
@end

@interface CODEPieChartInfoViewCell: UITableViewCell
@end


@implementation CODEPieChartTableViewCell

- (void) configureCell{
    CODEPieChart * pieChart = [[CODEPieChart alloc] initWithFrame:self.contentView.frame];
    [self.contentView addSubview:pieChart];
    
}

@end

@implementation CODEPieChartInfoViewCell
@end

@interface CODEPieChartInfoViewController ()

@end

@implementation CODEPieChartInfoViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row){
        case 0:return 320;
        default: return 44;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row){
        case 0:{
            CODEPieChartTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"CODEPieChartTableViewCell"];
            [cell configureCell];
            return cell;
        }
            break;
        default:{
            return [tableView dequeueReusableCellWithIdentifier:@"CODEPieChartInfoViewCell"];
        }
            break;
    }
}

@end
