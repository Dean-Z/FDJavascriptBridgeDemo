//
//  NameModel.h
//  Demo_GCD
//
//  Created by Jason on 2019/11/17.
//  Copyright © 2019 Jason. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol NMProtocol <JSExport>

@property NSString *name;

- (void)logTheName;
JSExportAs(getSum, - (void)sum:(int)a with:(int)b);

@end

@interface NameModel : NSObject <NMProtocol>


@end
