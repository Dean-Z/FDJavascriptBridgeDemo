//
//  NameModel.m
//  Demo_GCD
//
//  Created by Jason on 2019/11/17.
//  Copyright © 2019 Jason. All rights reserved.
//

#import "NameModel.h"

@implementation NameModel

@synthesize name = _name;

- (void)setName:(NSString *)name {
    _name = name;
}

- (void)logTheName {
    NSLog(@"asdasdsad");
}

- (void)sum:(int)a with:(int)b {
    NSLog(@"sum = %d",a+b);
}

@end
