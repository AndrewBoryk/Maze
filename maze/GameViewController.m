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
#import "BoardView.h"
#import "SpaceView.h"

@implementation GameViewController {
    Player *testPlayerBlue;
    
    Player *testPlayerRed;
    
    BoardView *boardView;
    
    Board *testBoard;
    
    /// Recognizes swipes on board left
    UISwipeGestureRecognizer *swipeRecognizerLeft;
    
    /// Recognizes swipes on board right
    UISwipeGestureRecognizer *swipeRecognizerRight;
    
    /// Recognizes swipes on board up
    UISwipeGestureRecognizer *swipeRecognizerUp;
    
    /// Recognizes swipes on board down
    UISwipeGestureRecognizer *swipeRecognizerDown;
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
    
    testBoard = [[Board alloc] initWithWidth:21 height:21];
    
    [testBoard replacePoint:CGPointMake(testBoard.width / 2, 1) withType:SpaceTypeEnemyHome];
    [testBoard replacePoint:CGPointMake(testBoard.width / 2, testBoard.height - 2) withType:SpaceTypeFriendlyHome];
    
    boardView = [[BoardView alloc] initWithBoard:testBoard];
    
    testPlayerBlue = [[Player alloc] initWithType:PlayerTypeFriendly playerID:@"12345" withPosition:CGPointMake(testBoard.width / 2, testBoard.height - 2)];
    testPlayerRed = [[Player alloc] initWithType:PlayerTypeEnemy playerID:@"12346" withPosition:CGPointMake(testBoard.width / 2, 1)];
    
    [Player setCurrentPlayer:testPlayerBlue];
    
    [self setSwitchBackground];
    
    [boardView addPlayer:testPlayerBlue];
    [boardView addPlayer:testPlayerRed];
    
    [self.scrollView addSubview:boardView];
    
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
        [boardView movePlayer:player toPosition:newPosition];
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
    CGFloat rightEdgeBuffer = (boardView.frame.size.width - [Utils screenWidth]);
    CGFloat bottomEdgeBuffer = (boardView.frame.size.height - [Utils screenHeight]);
    
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

@end
