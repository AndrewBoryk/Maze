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

@implementation PlayerView {
    UIView *whiteCircle;
    
    UIView *centerCircle;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype) initWithPlayer: (Player *) player {
    self = [super init];
    
    if (self) {
        self.player = player;
        
        self.frame = CGRectMake(0, 0, [[SpaceView sharedInstance] defaultSpaceSize]*0.8f, [[SpaceView sharedInstance] defaultSpaceSize]*0.8f);
        self.layer.cornerRadius = self.frame.size.width / 2.0f;
        self.clipsToBounds = YES;
        
        self.layer.borderWidth = 1.0f;
        self.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.4f].CGColor;
        
        if (self.player.type == PlayerTypeFriendly) {
            self.backgroundColor = [Utils colorWithHexString:@"2980b9"];
        }
        else if (self.player.type == PlayerTypeEnemy) {
            self.backgroundColor = [Utils colorWithHexString:@"c0392b"];
        }
        
        whiteCircle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width * 0.8f, self.frame.size.width * 0.8f)];
        whiteCircle.backgroundColor = [Utils colorWithHexString:@"FCFCFC"];
        whiteCircle.layer.cornerRadius = whiteCircle.frame.size.width / 2.0f;
        
        centerCircle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, whiteCircle.frame.size.width * 0.8f, whiteCircle.frame.size.width * 0.8f)];
        centerCircle.backgroundColor = self.backgroundColor;
        centerCircle.layer.cornerRadius = centerCircle.frame.size.width / 2.0f;
        
        
        SpaceView *tempSpaceView = [[BoardView currentBoardView] spaceViewForPoint: player.position];
        self.center = tempSpaceView.center;
        
        whiteCircle.center = CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f);
        centerCircle.center = CGPointMake(self.frame.size.width/2.0f, self.frame.size.height/2.0f);
        
        [self addSubview:whiteCircle];
        [self addSubview:centerCircle];
    }
    
    return self;
}
@end
