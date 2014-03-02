//
//  CODEPieChartInfoViewController.m
//  CODE2014
//
//  Created by Allan Chu on 2014-03-01.
//  Copyright (c) 2014 Nobis Studios. All rights reserved.
//

#import "CODEPieChartInfoViewController.h"
#import "CODEPieChart.h"
#import "CODEDataManager.h"


@interface CODECharityCostCells: UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *charitableCostLabel;
@property (nonatomic, weak) IBOutlet UILabel *managementCostLabel;
@property (nonatomic, weak) IBOutlet UILabel *fundraisingLabel;
@property (nonatomic, weak) IBOutlet UILabel *politicalLabel;
@property (nonatomic, weak) IBOutlet UILabel *otherExpensesLabel;
@property (nonatomic, weak) IBOutlet UILabel *totalLabel;
- (void) configureCell: (PFObject *) fiscalInfo;
@end

@implementation CODECharityCostCells
- (void) configureCell: (PFObject *) fiscalInfo{
    if (fiscalInfo[@"f5000"] != nil){
        self.charitableCostLabel.text = fiscalInfo[@"f5000"];
    }else {
        self.charitableCostLabel.text = @"N/A";
    }
    
    if (fiscalInfo[@"f5010"] != nil){
        self.managementCostLabel.text = fiscalInfo[@"f5010"];
    }else {
        self.managementCostLabel.text = @"N/A";
    }
    
    if (fiscalInfo[@"f5020"] != nil){
        self.fundraisingLabel.text = fiscalInfo[@"f5020"];
    }else {
        self.fundraisingLabel.text = @"N/A";
    }
    
    if (fiscalInfo[@"f5030"] != nil){
        self.politicalLabel.text = fiscalInfo[@"f5030"];
    }else {
        self.politicalLabel.text = @"N/A";
    }
    
    if (fiscalInfo[@"f5040"] != nil){
        self.otherExpensesLabel.text = fiscalInfo[@"f5040"];
    }else {
        self.otherExpensesLabel.text = @"N/A";
    }
    
    if (fiscalInfo[@"f5100"] != nil){
        self.totalLabel.text = fiscalInfo[@"f5100"];
    }else {
        self.totalLabel.text = @"N/A";
    }

}
@end

@interface CODECharityDonationCell: UITableViewCell
@end

@implementation CODECharityDonationCell
@end

@interface CODECharityOrganizationInfoCell: UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *orgNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *orgCategoryLabel;
@property (nonatomic, weak) IBOutlet UILabel *orgAddressLine1Label;
@property (nonatomic, weak) IBOutlet UILabel *orgAddressLine2Label;
@property (nonatomic, weak) IBOutlet UILabel *orgAddressLine3Label;
@property (nonatomic, weak) IBOutlet UILabel *orgBNLabel;
@end

@implementation CODECharityOrganizationInfoCell
- (void) configureCell: (PFObject *) organization {
    self.orgNameLabel.text = organization[@"Account_Name"];
    self.orgCategoryLabel.text = [self convertCategoryToString:[organization[@"Category"] intValue]];
    self.orgAddressLine1Label.text = organization[@"Address_Line_1"];
    self.orgAddressLine2Label.text = [NSString stringWithFormat:@"%@ %@", organization[@"City"], organization[@"Country"]];
    self.orgAddressLine3Label.text = [NSString stringWithFormat:@"%@", organization[@"Postal_Code"]];
    self.orgBNLabel.text = [NSString stringWithFormat:@"BN: %@", organization[@"BN"]];
}

- (NSString *) convertCategoryToString:(NSInteger) item {
    switch (item){
        case 1:return @"Organizations Providing Care Other than Treatment";
        case 2:return @"Disaster Funds";
        case 3:return @"(Welfare) Charitable Corporations";
        case 5:return @"(Welfare) Charitable Trusts";
        case 9:return @"Welfare Organizations (not else classified)";
        case 10:return @"Hospitals";
        case 11:return @"Services Other Than Hospitals";
        case 13:return @"(Health) Charitable Corporations";
        case 15:return @"(Health) Charitable Trusts";
        case 19:return @"Health Organizations, (not else classified)";
        case 20:return @"Teaching Institutions or Institutions of Learning";
        case 21:return @"Support of Schools and Education";
        case 22:return @"Cultural Activities and Promotion of the Arts";
        case 23:return @"(Education) Charitable Corporations";
        case 25:return @"(Education) Charitable Trusts";
        case 29:return @"Education Organizations, (not else classified)";
        case 30:return @"Anglican Parishes";
        case 31:return @"Baptist Congregations";
        case 32:return @"Lutheran Congregations";
        case 33:return @"Baha’ is Religious Groups";
        case 34:return @"Mennonite Congregations";
        case 35:return @"Buddhist Religious Groups";
        case 36:return @"Pentecostal Assemblies (Pentecostal Assemblies) of Canada only";
        case 37:return @"Presbyterian Congregations";
        case 38:return @"Roman Catholic Parishes and Chapels";
        case 39:return @"Other Denominations’ Congregations or Parishes, (not else classified)";
        case 40:return @"Salvation Army Temples";
        case 41:return @"Seventh Day Adventist Congregations";
        case 42:return @"Synagogues";
        case 43:return @"(Religion) Charitable Organizations";
        case 44:return @"United Church Congregations";
        case 45:return @"(Religion) Charitable Trusts";
        case 46:return @"Convents and Monasteries";
        case 47:return @"Missionary Organizations and Propagation of Gospel";
        case 48:return @"Hindu Religions Groups";
        case 49:return @"Religious Organizations, (not else classified)";
        case 60:return @"Islamic Religious Groups";
        case 61:return @"Jehovah’ Witnesses Congregations";
        case 62:return @"Sikh Religious Groups";
        case 50:return @"Libraries, Museums and Other Repositories";
        case 51:return @"Military Units";
        case 52:return @"Preservation of Sites, Beauty and Historical";
        case 53:return @"(Community) Charitable Corporations";
        case 54:return @"Protection of Animals";
        case 55:return @"(Community) Charitable Trusts (Other than Service Clubs and Fraternal Societies Projects)";
        case 56:return @"Recreation, Playgrounds and Vacation Camps";
        case 57:return @"Temperance Associations";
        case 59:return @"Community Organizations, (not else classified)";
        case 63:return @"Service Clubs and Fraternal Societies’ Charitable Corporations";
        case 65:return @"Service Clubs and Fraternal Societies’ Projects";
        case 75:return @"Employees’ Charity Trusts";
        case 80:return @"Registered Canadian Amateur Athletic Association (RCAAA)";
        case 81:return @"Registered National Arts Services Organization (RNASO)";
        case 83:return @"Corporation Funding Registered Canadian Amateur Athletic Association";
        case 85:return @"Trust Funding Registered Canadian Amateur Athletic Association";
        case 99:return @"Miscellaneous Charitable Organizations, (not else classified)";
        default:return @"Unknown";
    }
}
@end


@interface CODEPieChartTableViewCell: UITableViewCell
- (void) configureCell:(NSDictionary *) dictionary;
@end

@implementation CODEPieChartTableViewCell

- (void) configureCell:(NSDictionary *) dictionary{
    [[self.contentView subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CODEPieChart * pieChart = [[CODEPieChart alloc] initWithFrame:self.contentView.frame andDictionary:dictionary];
    [self.contentView addSubview:pieChart];
    
}

@end

@interface CODEPieChartInfoViewController ()
@property (nonatomic, strong) NSMutableDictionary *dictionaryOfInfoForPieGraph;
@property (nonatomic, strong) PFObject *fiscalInfoDictionary;


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
    self.dictionaryOfInfoForPieGraph = [NSMutableDictionary dictionary];
    [[CODEDataManager manager] getBusinessFinancialNumbers:self.selectedOrganization withBlock:^(NSArray *items, NSError *error) {
        PFObject *object = [items firstObject]; //there should only ever be one object//
        self.fiscalInfoDictionary = object;
        if (object[@"f5000"] != nil){
            [self.dictionaryOfInfoForPieGraph setObject:object[@"f5000"] forKey:@"5000"];
        }
        if (object[@"f5010"] != nil){
            [self.dictionaryOfInfoForPieGraph setObject:object[@"f5010"] forKey:@"5010"];
        }
        if (object[@"f5020"] != nil){
            [self.dictionaryOfInfoForPieGraph setObject:object[@"f5020"] forKey:@"5020"];
        }
        if (object[@"f5030"] != nil){
            [self.dictionaryOfInfoForPieGraph setObject:object[@"f5030"] forKey:@"5030"];
        }
        if (object[@"f5040"] != nil){
            [self.dictionaryOfInfoForPieGraph setObject:object[@"f5040"] forKey:@"5040"];
        }
        if (object[@"f5100"] != nil){
            [self.dictionaryOfInfoForPieGraph setObject:object[@"f5100"] forKey:@"5100"];
        }
        
        CODEDebugLog(@"%@", self.dictionaryOfInfoForPieGraph);
        [self.pieTableView reloadData];
        
    }];
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
    return 4;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row){
        case 0:return 220;
        case 1:return 150;
        case 2:return 320;
        case 3:return 180;
        default: return 44;
    }
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row){
        case 0:{
            CODECharityOrganizationInfoCell * cell =[tableView dequeueReusableCellWithIdentifier:@"CODECharityOrganizationInfoCell"];
            [cell configureCell:self.selectedOrganization];
            return cell;
        }
            break;
        case 1:{
            CODECharityDonationCell * cell =[tableView dequeueReusableCellWithIdentifier:@"CODECharityDonationCell"];
            return cell;
            
        }
            break;
        case 2:{
            CODEPieChartTableViewCell * cell =[ tableView dequeueReusableCellWithIdentifier:@"CODEPieChartTableViewCell"];
            [cell configureCell:self.dictionaryOfInfoForPieGraph];
            return cell;
        }
            break;
        case 3: {
            CODECharityCostCells *cell = [tableView dequeueReusableCellWithIdentifier:@"CODECharityCostCells"];
            [cell configureCell:self.fiscalInfoDictionary];
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
