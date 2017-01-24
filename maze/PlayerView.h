//
//  PlayerView.h
//  maze
//
//  Created by Andrew Boryk on 1/23/17.
//  Copyright © 2017 Andrew Boryk. All rights reserved.
//

#import "Maze-Prefix.pch"
#import "Player.h"
#import "BoardView.h"


@interface PlayerView : UIView

/// Player associated with view
@property (strong, nonatomic) Player *player;

/// Initialize a playerView
- (instancetype) initWithPlayer: (Player *) player inBoard: (BoardView *) boardView;
@end
