//
//  CODEPieChart.m
//  CODE2014
//
//  Created by Allan Chu on 2014-03-01.
//  Copyright (c) 2014 Nobis Studios. All rights reserved.
//

#import "CODEPieChart.h"
#import <math.h>
@interface CODEPieChart()
@property (nonatomic, strong) NSDictionary *infoDictionary;
@end

@implementation CODEPieChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // Initialization code
    }
    return self;
}

- (id) initWithFrame:(CGRect)frame andDictionary: (NSDictionary *) dictionary {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    self.infoDictionary = dictionary;
    
    return self;
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];

    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    int charitableActivities, expendituresManagement, fundraising, politicalActivities,totalSpending, otherSpending;
    totalSpending = [self.infoDictionary[@"5100"] intValue];

    float startAngle = 0.0f;
    float endAngle = 0.0f;
    
    if (self.infoDictionary[@"5000"] != nil){
        charitableActivities = [self.infoDictionary[@"5000"] intValue];
        double charitables = (M_PI *2) * ((double) charitableActivities/(double)totalSpending);
        CODEDebugLog(@"A %i", charitableActivities);
        
        UIColor *color = [UIColor colorWithRed:46.0f/255.0f green:77.0f/255.0f blue:88.0f/255.0f alpha:1.0f];
        endAngle = startAngle + charitables;
        CODEDebugLog(@"A %f, %f, %f", startAngle, endAngle, charitables);

        CGContextAddArc(ctx, 160, 160, 57, startAngle, endAngle, false);
        CGContextSetStrokeColorWithColor(ctx,color.CGColor);
        CGContextSetLineWidth(ctx, 114);
        CGContextStrokePath(ctx);
        startAngle = endAngle;

    }
    
    
    if (self.infoDictionary[@"5010"] != nil){
        expendituresManagement = [self.infoDictionary[@"5010"] intValue];
        CODEDebugLog(@"B %i", expendituresManagement);

        double expenditures = (M_PI *2) * ((double) expendituresManagement/(double)totalSpending);
        
        UIColor *color = [UIColor colorWithRed:21.0f/255.0f green:172.0f/255.0f blue:194.0f/255.0f alpha:1.0f];
        endAngle = startAngle + expenditures;
        CODEDebugLog(@"B %f, %f", endAngle, expenditures);

        CGContextAddArc(ctx, 160, 160, 57, startAngle, endAngle, false);
        CGContextSetStrokeColorWithColor(ctx,color.CGColor);
        CGContextSetLineWidth(ctx, 114);
        CGContextStrokePath(ctx);
        startAngle = endAngle;
        
    }
    
    if (self.infoDictionary[@"5020"] != nil){
        fundraising = [self.infoDictionary[@"5020"] intValue];
        CODEDebugLog(@"C %i", fundraising);

        double charitables = (M_PI *2) * ((double) fundraising/(double)totalSpending);
        
        UIColor *color = [UIColor colorWithRed:230.0f/255.0f green:214.0f/255.0f blue:131.0f/255.0f alpha:1.0f];
        endAngle = startAngle + charitables;
        CODEDebugLog(@"C %f, %f", endAngle, charitables);

        
        CGContextAddArc(ctx, 160, 160, 57, startAngle, endAngle, false);
        CGContextSetStrokeColorWithColor(ctx,color.CGColor);
        CGContextSetLineWidth(ctx, 114);
        CGContextStrokePath(ctx);
        startAngle = endAngle;
        
    }
    
    if (self.infoDictionary[@"5030"] != nil){
        politicalActivities = [self.infoDictionary[@"5030"] intValue];
        CODEDebugLog(@"D %i", politicalActivities);

        double management = (M_PI *2) * ((double) politicalActivities/(double)totalSpending);
        UIColor * color = [UIColor colorWithRed:126.0/255.0f green:113.0f/255.0f blue:130.0f/255.0f alpha:1.0f];
        
        endAngle = startAngle + management;
        CODEDebugLog(@"D %f, %f", endAngle, management);
        
        CGContextAddArc(ctx, 160, 160, 57, startAngle, endAngle, false);
        CGContextSetStrokeColorWithColor(ctx,color.CGColor);
        CGContextSetLineWidth(ctx, 114);
        CGContextStrokePath(ctx);
        startAngle = endAngle;
        
    }
    
    if (self.infoDictionary[@"5040"] != nil){
        otherSpending = [self.infoDictionary[@"5040"] intValue];
        double charitables = (M_PI *2) * ((double) otherSpending/(double)totalSpending);
        CODEDebugLog(@"E %i", otherSpending);

        UIColor *color = [UIColor colorWithRed:243.0f/255.0f green:98.0f/255.0f blue:88.0f/255.0f alpha:1.0f];
        endAngle = startAngle + charitables;
        CODEDebugLog(@"E %f, %f", endAngle, charitables);

    
        CGContextAddArc(ctx, 160, 160, 57, startAngle, endAngle, false);
        CGContextSetStrokeColorWithColor(ctx,color.CGColor);
        CGContextSetLineWidth(ctx, 114);
        CGContextStrokePath(ctx);
        startAngle = endAngle;
        
    }
    /*
    if (startAngle == 0.0f){
    UIColor *color = [UIColor colorWithRed:175.0f/255.0f green:173.0f/255.0f blue:176.0f/255.0f alpha:1.0f];
    CODEDebugLog(@"H %f, %f", startAngle, endAngle);

    CGContextAddArc(ctx, 160, 160, 57, startAngle, M_PI *2, false);
    CGContextSetStrokeColorWithColor(ctx,color.CGColor);
    CGContextSetLineWidth(ctx, 114);
    CGContextStrokePath(ctx);
    }
    */
    
    
}



@end
