//
//  Appearance.h
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "Utils.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Appearance : UIView

/// Background color for board
+ (UIColor *) boardBackgroundColor;

/// Color for an empty wall
+ (UIColor *) emptyWallColor;
@end
