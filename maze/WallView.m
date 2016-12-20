//
//  Wall.m
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "WallView.h"

@implementation WallView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype) init {
    self = [super init];
    
    if (self) {
        [self setWallVisible:false];
    }
    
    return self;
}

- (instancetype) initWithSide:(DirectionType)direction size:(CGFloat)size {
    self = [super init];
    
    if (self) {
        
        self.sideType = direction;
        self.size = size;
        
        CGFloat tenPercentWidth = size * 0.1f;
        
        if (direction == DirectionLeft) {
            self = [[WallView alloc] initWithFrame:CGRectMake(-(tenPercentWidth/2.0f), -(tenPercentWidth/2.0f), tenPercentWidth, size + tenPercentWidth)];
        }
        else if (direction == DirectionRight) {
            self = [[WallView alloc] initWithFrame:CGRectMake(size - (tenPercentWidth/2.0f), -(tenPercentWidth/2.0f), tenPercentWidth, size + tenPercentWidth)];
        }
        else if (direction == DirectionUp) {
            self = [[WallView alloc] initWithFrame:CGRectMake(-(tenPercentWidth/2.0f), -(tenPercentWidth/2.0f), size + tenPercentWidth, tenPercentWidth)];
        }
        else if (direction == DirectionDown) {
            self = [[WallView alloc] initWithFrame:CGRectMake(-(tenPercentWidth/2.0f), size - (tenPercentWidth/2.0f), size + tenPercentWidth, tenPercentWidth)];
        }
    }
    
    return self;
}

- (void) setWallVisible:(BOOL)visible {
    self.isWallVisible = visible;
    
    if (self.isWallVisible) {
        self.backgroundColor = [UIColor yellowColor];
        if ([Utils notNull:self.superview]) {
            [self.superview bringSubviewToFront:self];
        }
    }
    else {
        self.backgroundColor = [Appearance emptyWallColor];
    }
}
@end
