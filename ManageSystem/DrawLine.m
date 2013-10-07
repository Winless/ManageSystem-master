//
//  DrawLine.m
//  ManageSystem
//
//  Created by wjj on 13-10-5.
//  Copyright (c) 2013年 WN. All rights reserved.
//

#import "DrawLine.h"

@implementation DrawLine

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();

   for (int i = 0; i <= 7; i++)
    {
        CGContextMoveToPoint(context, i * 46- 2, 33.5 - pointZero);
        CGContextAddLineToPoint(context, i * 46 - 2, 192.8 - pointZero);
        CGContextStrokePath(context);

    }
    CGContextMoveToPoint(context, 0, 32.3  - pointZero);
    CGContextAddLineToPoint(context, 360, 32.3  - pointZero);
    CGContextStrokePath(context);
    for(int i = 1;i < 7;i++)
    {
        CGContextMoveToPoint(context, 0, 32 + i * 27 - pointZero);
        CGContextAddLineToPoint(context, 360, 32 + i * 27 - pointZero);
        CGContextStrokePath(context);
    }
    CGContextMoveToPoint(context, 0, 243 - pointZero);
    CGContextAddLineToPoint(context, 316, 243 - pointZero);
    CGContextStrokePath(context);
    CGContextMoveToPoint(context, 0, 266 - pointZero);
    CGContextAddLineToPoint(context, 316, 266 - pointZero);
    CGContextStrokePath(context);
    CGContextMoveToPoint(context, 0, 289 - pointZero);
    CGContextAddLineToPoint(context, 299, 289 - pointZero);
    CGContextStrokePath(context);
    CGContextMoveToPoint(context, 0, 303 - pointZero);
    CGContextAddLineToPoint(context, 316, 303 - pointZero);
    CGContextStrokePath(context);
    CGContextMoveToPoint(context, 0, 326 - pointZero);
    CGContextAddLineToPoint(context, 316, 326 - pointZero);
    CGContextStrokePath(context);
    CGContextMoveToPoint(context, 0, 349 - pointZero);
    CGContextAddLineToPoint(context, 299, 349 - pointZero);
    CGContextStrokePath(context);
    for (int i = 0;i < 5;i++)
    {
        CGContextMoveToPoint(context, 35.75*i - 2, 243 - pointZero);
        CGContextAddLineToPoint(context, 35.75*i - 2, 266 - pointZero);
        CGContextStrokePath(context);
    }
    CGContextMoveToPoint(context, 175, 243 - pointZero);
    CGContextAddLineToPoint(context, 175, 266 - pointZero);
    CGContextStrokePath(context);
    for (int i = 1;i < 5;i++)
    {
        CGContextMoveToPoint(context, 35.5*i +173, 243 - pointZero);
        CGContextAddLineToPoint(context, 35.5*i +173, 266 - pointZero);
        CGContextStrokePath(context);
    }
    for (int i = 0;i < 9;i++)
    {
        CGContextMoveToPoint(context, 35.5*i +50, 266 - pointZero);
        CGContextAddLineToPoint(context, 35.5*i +50, 289 - pointZero);
        CGContextStrokePath(context);
    }
    
    for (int i = 0;i < 5;i++)
    {
        CGContextMoveToPoint(context, 35.75*i - 2, 303 - pointZero);
        CGContextAddLineToPoint(context, 35.75*i - 2, 326 - pointZero);
        CGContextStrokePath(context);
    }
    CGContextMoveToPoint(context, 175, 303 - pointZero);
    CGContextAddLineToPoint(context, 175, 326 - pointZero);
    CGContextStrokePath(context);
    for (int i = 1;i < 5;i++)
    {
        CGContextMoveToPoint(context, 35.5*i +173, 303 - pointZero);
        CGContextAddLineToPoint(context, 35.5*i +173, 326 - pointZero);
        CGContextStrokePath(context);
    }
    
    for (int i = 0;i < 9;i++)
    {
        CGContextMoveToPoint(context, 35.5*i +50, 326 - pointZero);
        CGContextAddLineToPoint(context, 35.5*i +50, 349 - pointZero);
        CGContextStrokePath(context);
    }
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
