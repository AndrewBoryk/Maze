//
//  GameViewController.h
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>
#import "BoardView.h"

@interface GameViewController : UIViewController <UIGestureRecognizerDelegate, UIScrollViewDelegate, BoardViewDelegate>

/// Scroll view for board
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

/// Button to switch players during testing
@property (strong, nonatomic) IBOutlet UIButton *switchPlayerButton;

/// Switch players during testing
- (IBAction)switchPlayerAction:(id)sender;

/// View which shows progress of capturing objective one
@property (strong, nonatomic) IBOutlet UIView *objectiveOneView;

/// View which shows progress of capturing objective two
@property (strong, nonatomic) IBOutlet UIView *objectiveTwoView;

/// View which shows progress of capturing objective three
@property (strong, nonatomic) IBOutlet UIView *objectiveThreeView;

@end
