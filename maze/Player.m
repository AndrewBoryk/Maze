//
//  Player.m
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "Player.h"

@implementation Player

- (instancetype) initWithType:(PlayerType) type playerID:(NSString *)playerID withPosition: (CGPoint) position {
    self = [super init];
    
    if (self) {
        self.playerID = playerID;
        self.type = type;
        self.position = position;
    }
    
    return self;
}
@end
