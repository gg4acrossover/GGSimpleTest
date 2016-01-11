//
//  GGParseLeftMenu.h
//  GGSimpleTest
//
//  Created by viethq on 8/31/15.
//  Copyright (c) 2015 viethq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGParseLeftMenu : NSObject

@property(nonatomic, assign, readonly) NSInteger mNumberSection;

-(NSInteger)gg_numberOfRowInSection:(NSInteger)section;
-(NSString*)gg_strClassForRow:(NSInteger)row inSection:(NSInteger)section;
-(NSString*)gg_titleForRow:(NSInteger)row inSection:(NSInteger)section;
-(NSString*)gg_titleForSection:(NSInteger)section;

@end
