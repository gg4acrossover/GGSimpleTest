//
//  GGParseLeftMenu.m
//  GGSimpleTest
//
//  Created by viethq on 8/31/15.
//  Copyright (c) 2015 viethq. All rights reserved.
//

#import "GGParseLeftMenu.h"

@interface GGParseLeftMenu()

@property(nonatomic, strong) NSDictionary *mTree;
@property(nonatomic, assign) NSInteger mNumberSection;

@end

@implementation GGParseLeftMenu

-(instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.mTree = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"menuLeft" ofType:@"plist"]];
        self.mNumberSection = [self.mTree allKeys].count;
    }
    
    return self;
}

-(NSString*)gg_titleForSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"SECTION_%li", section];
}

-(NSArray*)gg_arrItemInSection:(NSInteger)section
{
    NSString *pKeySection = [NSString stringWithFormat:@"SECTION_%li", section];
    NSArray *pArrTitleSecton = self.mTree[pKeySection];
    
    return pArrTitleSecton;
}

-(NSDictionary*)gg_dataForRow:(NSInteger)row inSection:(NSInteger)section
{
    NSArray *pArrTitle = [self gg_arrItemInSection:section];
    return pArrTitle[row];
}

-(NSString*)gg_titleForRow:(NSInteger)row inSection:(NSInteger)section
{
    NSDictionary *pDictCell = [self gg_dataForRow:row inSection:section];
    return [[pDictCell allKeys] firstObject];
}

-(NSString*)gg_strClassForRow:(NSInteger)row inSection:(NSInteger)section
{
    NSDictionary *pDictCell = [self gg_dataForRow:row inSection:section];
    NSString *pKey = [[pDictCell allKeys] firstObject];
    return pDictCell[pKey];
}

-(NSInteger)gg_numberOfRowInSection:(NSInteger)section
{
    NSArray *pArrTitle = [self gg_arrItemInSection:section];
    return pArrTitle.count;
}

@end
