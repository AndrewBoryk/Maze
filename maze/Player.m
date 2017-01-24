//
//  Player.m
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "Player.h"

@implementation Player

+ (id)sharedInstance {
    static Player *sharedMyInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyInstance = [[self alloc] init];
        
    });
    return sharedMyInstance;
}

+ (void) setCurrentPlayer: (Player *) player{
    [[Player sharedInstance] setCurrentPlayerInstance:player];
}

+ (Player *) currentPlayer {
    return [[Player sharedInstance] currentPlayerInstance];
}
     
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
