//
//  Appearance.m
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "Appearance.h"

@implementation Appearance

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (UIColor *) boardBackgroundColor {
//    [Utils colorWithHexString:@"0B1E30"];
    return [Utils colorWithHexString:@"FCFCFC"];
}

+ (UIColor *) emptyWallColor {
    return [Utils colorWithHexString:@"262626"];
}
@end
