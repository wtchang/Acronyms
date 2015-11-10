//
//  Var.h
//  Acronyms
//
//  Created by William Chang on 11/9/15.
//  Copyright © 2015 WillChang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
@protocol Var
@end

@interface Var : JSONModel
@property NSString* lf;
@property int freq;
@property int since;
@end



