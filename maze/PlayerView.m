//
//  PlayerView.m
//  maze
//
//  Created by Andrew Boryk on 1/23/17.
//  Copyright © 2017 Andrew Boryk. All rights reserved.
//

#import "PlayerView.h"
#import "SpaceView.h"
#import "BoardView.h"

@implementation PlayerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype) initWithPlayer: (Player *) player inBoard: (BoardView *) boardView {
    self = [super init];
    
    if (self) {
        self.player = player;
        
        self.frame = CGRectMake(0, 0, [[SpaceView sharedInstance] defaultSpaceSize]/2.0f, [[SpaceView sharedInstance] defaultSpaceSize]/2.0f);
        self.layer.cornerRadius = self.frame.size.width / 2.0f;
        self.clipsToBounds = YES;
        
        if (self.player.type == PlayerTypeFriendly) {
            self.backgroundColor = [Utils colorWithHexString:@"2980b9"];
        }
        else if (self.player.type == PlayerTypeEnemy) {
            self.backgroundColor = [Utils colorWithHexString:@"c0392b"];
        }
        
        
        
        SpaceView *tempSpaceView = [boardView spaceViewForPoint: player.position];
        self.center = tempSpaceView.center;
        
    }
    
    return self;
}
@end
