//
//  Enums.h
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// Type of Wall
typedef NS_ENUM(NSInteger, WallType) {
    WallTypeNone, // 0
    WallTypeLeft, // 1
    WallTypeRight,  // 2
    WallTypeUp,  // 3
    WallTypeDown,  // 4
    WallTypeLeftRight,  // 5
    WallTypeLeftUp,  // 6
    WallTypeLeftDown,  // 7
    WallTypeRightUp,  // 8
    WallTypeRightDown,  // 9
    WallTypeUpDown,  // 10
    WallTypeLeftRightUp,  // 11
    WallTypeLeftRightDown,  // 12
    WallTypeLeftUpDown,  // 13
    WallTypeRightUpDown,  // 14
    WallTypeLeftRightUpDown,  // 15
};

/// Type of Space or Player
typedef NS_ENUM(NSInteger, ItemType) {
    ItemTypeEmpty, // 0
    ItemTypeFriendly,  // 1
    ItemTypeEnemy,  // 2
    ItemTypeWall,  // 3
};

/// State of player (AI)
typedef NS_ENUM(NSInteger, PlayerState) {
    StateAttacking, // 0
    StateDefending,  // 1
    StateCapturing,  // 2
    StateRetreating,  // 3
};

/// Direction types
typedef NS_ENUM(NSInteger, DirectionType) {
    DirectionLeft,
    DirectionRight,
    DirectionUp,
    DirectionDown,
};

@interface Enums : NSObject

@end
