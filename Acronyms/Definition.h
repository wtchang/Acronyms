//
//  Definition.h
//  Acronyms
//
//  Created by William Chang on 11/9/15.
//  Copyright © 2015 WillChang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "Var.h"

@protocol Definition
@end

@interface Definition: JSONModel
@property NSString* lf;
@property int freq;
@property int since;
@property NSArray<Var> *vars;

@end


