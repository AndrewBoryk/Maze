//
//  GameViewController.m
//  maze
//
//  Created by Andrew Boryk on 12/20/16.
//  Copyright © 2016 Andrew Boryk. All rights reserved.
//

#import "GameViewController.h"
#import "GameScene.h"
#import "Board.h"

#import "SpaceView.h"
#import <CoreMotion/CoreMotion.h>

@implementation GameViewController  {
    Player *testPlayerBlue;
    
    Player *testPlayerRed;
    
    /// Recognizes swipes on board left
    UISwipeGestureRecognizer *swipeRecognizerLeft;
    
    /// Recognizes swipes on board right
    UISwipeGestureRecognizer *swipeRecognizerRight;
    
    /// Recognizes swipes on board up
    UISwipeGestureRecognizer *swipeRecognizerUp;
    
    /// Recognizes swipes on board down
    UISwipeGestureRecognizer *swipeRecognizerDown;
    
    /// Manages motion
    CMMotionManager *manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Load the SKScene from 'GameScene.sks'
    //GameScene *scene = (GameScene *)[SKScene nodeWithFileNamed:@"GameScene"];
    
    // Set the scale mode to scale to fit the window
    //scene.scaleMode = SKSceneScaleModeAspectFill;
    
    //SKView *skView = (SKView *)self.view;
    
    self.switchPlayerButton.layer.cornerRadius = 6.0f;
    
    [[SpaceView sharedInstance] setDefaultSpaceSize:60.0f];
    
    Board *mainBoard = [[Board alloc] initWithWidth:21 height:21];

    
    [Board setCurrentBoard:mainBoard];
    
    testPlayerBlue = [[Player alloc] initWithType:PlayerTypeFriendly playerID:@"12345" withPosition:CGPointMake([Board currentBoard].width / 2, [Board currentBoard].height - 2)];
    testPlayerBlue.dataSource = self;
    
    testPlayerRed = [[Player alloc] initWithType:PlayerTypeEnemy playerID:@"12346" withPosition:CGPointMake([Board currentBoard].width / 2, 1)];
    
    [Player setCurrentPlayer:testPlayerBlue];
    
    [self setSwitchBackground];
    
    BoardView *mainBoardView = [[BoardView alloc] initWithBoard:mainBoard];
    mainBoardView.delegate = self;
    
    [BoardView setCurrentBoardView:mainBoardView];
    
    Space *friendlyHome = [[Space alloc] initWithType:SpaceTypeFriendly position:CGPointMake([Board currentBoard].width / 2, [Board currentBoard].height - 2)];
    friendlyHome.isBase = YES;
    
    Space *enemyHome = [[Space alloc] initWithType:SpaceTypeEnemy position:CGPointMake([Board currentBoard].width / 2, 1)];
    enemyHome.isBase = YES;
    
    Space *emptyFlagOne = [[Space alloc] initWithType:SpaceTypeEmpty position:CGPointMake([Board currentBoard].width / 2, [Board currentBoard].height/2)];
    emptyFlagOne.isFlag = YES;
    
    Space *emptyFlagTwo = [[Space alloc] initWithType:SpaceTypeEmpty position:CGPointMake([Board currentBoard].width / 2 + 2, [Board currentBoard].height/2)];
    emptyFlagTwo.isFlag = YES;
    
    Space *emptyFlagThree = [[Space alloc] initWithType:SpaceTypeEmpty position:CGPointMake([Board currentBoard].width / 2 - 2, [Board currentBoard].height/2)];
    emptyFlagThree.isFlag = YES;
    
    [[Board currentBoard] replacePoint:friendlyHome.position withSpace:friendlyHome];
    [[Board currentBoard] replacePoint:enemyHome.position withSpace:enemyHome];
    [[BoardView currentBoardView] setObjectiveOne:emptyFlagOne];
    [[BoardView currentBoardView] setObjectiveTwo:emptyFlagTwo];
    [[BoardView currentBoardView] setObjectiveThree:emptyFlagThree];
    
    [[BoardView currentBoardView] addPlayer:testPlayerBlue];
    [[BoardView currentBoardView] addPlayer:testPlayerRed];
    
    
    
    [self.scrollView addSubview:[BoardView currentBoardView]];
    
//    [Utils print:testBoard.boardArray tag:@"Board"];
    //[testBoard printBoard];
    
    
    swipeRecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    swipeRecognizerLeft.direction = (UISwipeGestureRecognizerDirectionLeft);
    swipeRecognizerLeft.delegate = self;
    
    swipeRecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    swipeRecognizerRight.direction = (UISwipeGestureRecognizerDirectionRight);
    swipeRecognizerRight.delegate = self;
    
    swipeRecognizerDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeDown:)];
    swipeRecognizerDown.direction = (UISwipeGestureRecognizerDirectionDown);
    swipeRecognizerDown.delegate = self;
    
    swipeRecognizerUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeUp:)];
    swipeRecognizerUp.direction = (UISwipeGestureRecognizerDirectionUp);
    swipeRecognizerUp.delegate = self;
    
    
    [self.view addGestureRecognizer:swipeRecognizerLeft];
    [self.view addGestureRecognizer:swipeRecognizerRight];
    [self.view addGestureRecognizer:swipeRecognizerDown];
    [self.view addGestureRecognizer:swipeRecognizerUp];
    
    [self setScrollOffset];
    
    // Present the scene
    //[skView presentScene:scene];
    
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
    
    self.scrollView.clipsToBounds = NO;
//    manager = [[CMMotionManager alloc] init];
//    
//    if (manager.deviceMotionAvailable) {
//        manager.deviceMotionUpdateInterval = 0.01f;
//        [manager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
//                                     withHandler:^(CMDeviceMotion *data, NSError *error) {
//                                         double rotation = atan2(data.gravity.x, data.gravity.y) - M_PI;
//                                         self.scrollView.transform = CGAffineTransformMakeRotation(rotation);
//                                     }];
//    }
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

int gcd (int a, int b){
    int c;
    while ( a != 0 ) {
        c = a; a = b%a; b = c;
    }
    return b;
}

- (void) handleSwipeLeft: (UISwipeGestureRecognizer *)gesture {
    [self movePlayer:[Player currentPlayer] inDirection:DirectionLeft];
}

- (void) handleSwipeRight: (UISwipeGestureRecognizer *)gesture {
    [self movePlayer:[Player currentPlayer] inDirection:DirectionRight];
}

- (void) handleSwipeDown: (UISwipeGestureRecognizer *)gesture {
    [self movePlayer:[Player currentPlayer] inDirection:DirectionDown];
}

- (void) handleSwipeUp: (UISwipeGestureRecognizer *)gesture {
    [self movePlayer:[Player currentPlayer] inDirection:DirectionUp];
}

- (void) movePlayer: (Player *) player inDirection: (DirectionType) direction {
    CGPoint newPosition = player.position;
    
    
    
    if (direction == DirectionLeft) {
        newPosition.x--;
    }
    else if (direction == DirectionRight) {
        newPosition.x++;
    }
    else if (direction == DirectionUp) {
        newPosition.y--;
    }
    else if (direction == DirectionDown) {
        newPosition.y++;
    }
    
    
    [UIView animateWithDuration:0.2f animations:^{
        [[BoardView currentBoardView] movePlayer:player toPosition:newPosition];
    }];
    
    [self setScrollOffset];
    
    //[testBoard printBoard];
}

- (BOOL) gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void) setScrollOffset {
    CGFloat newContentOffsetX = ([Player currentPlayer].position.x + 1) * [[SpaceView sharedInstance] defaultSpaceSize] - ([[SpaceView sharedInstance] defaultSpaceSize]/2.0f) - [Utils screenWidth]/2.0f;
    CGFloat newContentOffsetY = ([Player currentPlayer].position.y + 1) * [[SpaceView sharedInstance] defaultSpaceSize] - ([[SpaceView sharedInstance] defaultSpaceSize]/2.0f) - [Utils screenHeight]/2.0f;
//    CGFloat newContentOffsetY = (([Player currentPlayer].position.y + 1) * [[SpaceView sharedInstance] defaultSpaceSize]) - [Utils screenHeight] + [[SpaceView sharedInstance] defaultSpaceSize];
    CGFloat rightEdgeBuffer = ([BoardView currentBoardView].frame.size.width - [Utils screenWidth]);
    CGFloat bottomEdgeBuffer = ([BoardView currentBoardView].frame.size.height - [Utils screenHeight]);
    
    //NSLog(@"Right edge buffer: %f", rightEdgeBuffer);
    if (newContentOffsetY < 0) {
        newContentOffsetY = 0;
    }
    else if (newContentOffsetY > bottomEdgeBuffer) {
        newContentOffsetY = bottomEdgeBuffer;
    }
    
    if (newContentOffsetX < 0) {
        newContentOffsetX = 0;
    }
    else if (newContentOffsetX > rightEdgeBuffer) {
        newContentOffsetX = rightEdgeBuffer;
    }
    
    [self.scrollView setContentOffset:CGPointMake(newContentOffsetX, newContentOffsetY) animated:YES];
    //NSLog(@"BoardView X: %f  Y: %f  Width: %f  Height: %f", boardView.frame.origin.x, boardView.frame.origin.y, boardView.frame.size.width, boardView.frame.size.height);
    //NSLog(@"Screen Width: %f  Height: %f", [Utils screenWidth], [Utils screenHeight]);
    //NSLog(@"Position Width: %f  Height: %f", [Player currentPlayer].position.x * [[SpaceView sharedInstance] defaultSpaceSize], ([Player currentPlayer].position.y * [[SpaceView sharedInstance] defaultSpaceSize]));
    //NSLog(@"Content Offset X: %f  Y: %f", newContentOffsetX, newContentOffsetY);
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id  _Nonnull context) {
        
        [self setScrollOffset];
        
    } completion:^(id  _Nonnull context) {
        
        // Change origin rect because the screen has rotated
        //        self.mediaView.originRect = self.mediaView.frame;
        
        [self setScrollOffset];
    }];
}
- (IBAction)switchPlayerAction:(id)sender {
    if ([[Player currentPlayer].playerID isEqualToString:testPlayerRed.playerID]) {
        [Player setCurrentPlayer:testPlayerBlue];
    }
    else if ([[Player currentPlayer].playerID isEqualToString:testPlayerBlue.playerID]) {
        [Player setCurrentPlayer:testPlayerRed];
    }
    
    [self setScrollOffset];
    [self setSwitchBackground];
}

- (void) setSwitchBackground {
    if ([Player currentPlayer].type == PlayerTypeEnemy) {
        self.switchPlayerButton.backgroundColor = [Utils colorWithHexString:@"2980b9"];
    }
    else if ([Player currentPlayer].type == PlayerTypeFriendly) {
        self.switchPlayerButton.backgroundColor = [Utils colorWithHexString:@"c0392b"];
    }
}

- (void) adjustedObjective:(NSInteger)objectiveNumber withSpaceView:(SpaceView *)spaceView {
    if (objectiveNumber == 1) {
        self.objectiveOneView.backgroundColor = spaceView.backgroundColor;
    }
    else if (objectiveNumber == 2) {
        self.objectiveTwoView.backgroundColor = spaceView.backgroundColor;
    }
    else if (objectiveNumber == 3) {
        self.objectiveThreeView.backgroundColor = spaceView.backgroundColor;
    }
}

- (Space *)objectiveSpaceForPlayer:(Player *)player {
    if ([player.playerID isEqualToString:@"12345"]) {
        int distanceObjectiveOne = 0;
        int distanceObjectiveTwo = 0;
        int distanceObjectiveThree = 0;
        
        if (player.type == PlayerTypeFriendly) {
            
            if ([Utils notNull:[[BoardView currentBoardView] flagOne]]) {
                if ([[BoardView currentBoardView] flagOne].space.type != SpaceTypeFriendly) {
                    Space *objectiveSpace = [[BoardView currentBoardView] flagOne].space;
                    distanceObjectiveOne = abs((int)objectiveSpace.position.x - (int)player.position.x) + abs((int)objectiveSpace.position.y - (int)player.position.y);
                }
            }
            
            if ([Utils notNull:[[BoardView currentBoardView] flagTwo]]) {
                if ([[BoardView currentBoardView] flagTwo].space.type != SpaceTypeFriendly) {
                    Space *objectiveSpace = [[BoardView currentBoardView] flagTwo].space;
                    distanceObjectiveTwo = abs((int)objectiveSpace.position.x - (int)player.position.x) + abs((int)objectiveSpace.position.y - (int)player.position.y);
                }
            }
            
            
            if ([Utils notNull:[[BoardView currentBoardView] flagThree]]) {
                if ([[BoardView currentBoardView] flagThree].space.type != SpaceTypeFriendly) {
                    Space *objectiveSpace = [[BoardView currentBoardView] flagThree].space;
                    distanceObjectiveThree = abs((int)objectiveSpace.position.x - (int)player.position.x) + abs((int)objectiveSpace.position.y - (int)player.position.y);
                }
            }
            
        }
        
        if (distanceObjectiveOne != 0) {
            if (distanceObjectiveTwo < distanceObjectiveOne && distanceObjectiveTwo != 0) {
                if (distanceObjectiveThree < distanceObjectiveTwo && distanceObjectiveThree != 0) {
                    return [[BoardView currentBoardView] flagThree].space;
                }
                else {
                    return [[BoardView currentBoardView] flagTwo].space;
                }
            }
            else if (distanceObjectiveThree < distanceObjectiveOne && distanceObjectiveThree != 0) {
                return [[BoardView currentBoardView] flagThree].space;
            }
            else {
                return [[BoardView currentBoardView] flagOne].space;
            }
        }
        else if (distanceObjectiveTwo != 0) {
            if (distanceObjectiveThree < distanceObjectiveTwo && distanceObjectiveThree != 0) {
                return [[BoardView currentBoardView] flagThree].space;
            }
            else {
                return [[BoardView currentBoardView] flagTwo].space;
            }
        }
        else if (distanceObjectiveThree != 0) {
            return [[BoardView currentBoardView] flagThree].space;
        }
    }
    
    return nil;
}
@end
