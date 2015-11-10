//
//  Acronym.h
//  Acronyms
//
//  Created by William Chang on 11/9/15.
//  Copyright © 2015 WillChang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "Definition.h"


@interface Acronym : JSONModel
@property NSArray<Definition> *lfs;
@property NSString* sf;
@end



