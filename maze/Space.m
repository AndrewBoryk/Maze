//
//  Wall.m
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "Space.h"

@implementation Space

- (instancetype) init {
    self = [super init];
    
    if (self) {
        self.type = WallTypeNone;
        self.leftSide = 0;
        self.rightSide = 0;
        self.upSide = 0;
        self.downSide = 0;
    }
    
    return self;
}

- (instancetype) initWithType: (WallType) wall position: (CGPoint)position {
    self = [self init];
    
    if (self) {
        
        self.type = wall;
        self.position = position;
        
        if (wall == WallTypeLeft || wall == WallTypeLeftRight || wall == WallTypeLeftUp || wall == WallTypeLeftDown || wall == WallTypeLeftRightUp || wall == WallTypeLeftRightDown || wall == WallTypeLeftRightUpDown || wall == WallTypeLeftUpDown) {
            self.leftSide = YES;
        }
        
        if (wall == WallTypeRight || wall == WallTypeLeftRight || wall == WallTypeRightUp || wall == WallTypeRightDown || wall == WallTypeLeftRightUp || wall == WallTypeLeftRightDown || wall == WallTypeLeftRightUpDown || wall == WallTypeRightUpDown) {
            self.rightSide = YES;
        }
        
        if (wall == WallTypeUp || wall == WallTypeUpDown || wall == WallTypeLeftUp || wall == WallTypeRightUp || wall == WallTypeLeftRightUp || wall == WallTypeRightUpDown || wall == WallTypeLeftRightUpDown || wall == WallTypeLeftUpDown) {
            self.upSide = YES;
        }
        
        if (wall == WallTypeDown || wall == WallTypeUpDown || wall == WallTypeLeftDown || wall == WallTypeRightDown || wall == WallTypeLeftRightDown || wall == WallTypeRightUpDown || wall == WallTypeLeftRightUpDown || wall == WallTypeLeftUpDown) {
            self.downSide = YES;
        }
    }
    
    return self;
}

+ (BOOL) canPass:(WallType)wall direction:(DirectionType)direction {
    
    Space *testWall = [[Space alloc] initWithType:wall position:CGPointZero];
    
    switch (direction) {
        case DirectionLeft:
            return !testWall.leftSide;
            break;
        case DirectionRight:
            return !testWall.rightSide;
            break;
        case DirectionUp:
            return !testWall.upSide;
            break;
        case DirectionDown:
            return !testWall.downSide;
            break;
            
        default:
            break;
    }
    
    return NO;
}

@end
