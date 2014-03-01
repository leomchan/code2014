//
//  CODEPieChart.m
//  CODE2014
//
//  Created by Allan Chu on 2014-03-01.
//  Copyright (c) 2014 Nobis Studios. All rights reserved.
//

#import "CODEPieChart.h"

@implementation CODEPieChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    int numSections = 6;
    
    float startAngle = M_PI_2;
    float anglePerPie = (M_PI * 2)/numSections;
    float endAngle = 0.0f;
    
    for (int i = 0; i < numSections; i++){
        UIColor *color = [self getRandomUIColor];
        
        endAngle = startAngle + anglePerPie;
        
        CGContextAddArc(ctx, 160, 160, 20, startAngle, endAngle, false);
        CGContextSetStrokeColorWithColor(ctx,color.CGColor);
        CGContextSetLineWidth(ctx, 140);
        CGContextStrokePath(ctx);
        startAngle = endAngle;
    }
}

- (UIColor *)getRandomUIColor
{
    CGFloat r = arc4random() % 255;
    CGFloat g = arc4random() % 255;
    CGFloat b = arc4random() % 255;
    UIColor * color = [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:1.0f];
    return color;
}



@end
