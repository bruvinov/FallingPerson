//
//  ViewController.m
//  FallingPersons
//
//  Created by Boris Ruvinov on 3/30/16.
//  Copyright © 2016 Boris Ruvinov. All rights reserved.
//

#import "ViewController.h"
#import "DraggableView.h"

@interface ViewController ()
@end

@implementation ViewController {
    CGRect screenRect;
    CGFloat screenWidth;
    CGFloat screenHeight;
    BOOL firstTime;
    int score;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    screenRect = [[UIScreen mainScreen] bounds];
    screenWidth = screenRect.size.width;
    screenHeight = screenRect.size.height;
    score = 0;
    
    [self loadTrampoline];    //INIT TRAMPOLINE
    [self loadLoginButton];    //INIT LOGIN BUTTON
    [self loadStartButton];    //INIT START BUTTON


    //SHOW START BUTTON AND GAME SCORE
    [self.view addSubview:self.startButton];
    [self.view addSubview:self.loginButton];
    [self loadGameScore];
}

/*-=-=-=-=-=-=-=-=-=-=-=-=LOAD INTERFACE METHODS=-=-=-=-=-=-=-=-=-=-=-=-*/
- (void)loadGameScore {
    self.scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 30, 30)];
    self.scoreLabel.text = @"0";
    [self.view addSubview:self.scoreLabel];
}

- (void)loadTrampoline {
    self.draggableView = [[DraggableView alloc]initWithFrame:CGRectMake(screenWidth/2-50, screenHeight-35, 100, 35)];
    UIImageView *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Trampoline.png"]];
    imageview.frame = self.draggableView.bounds;
    imageview.contentMode = UIViewContentModeScaleToFill;
    [self.draggableView addSubview:imageview];
    [self.view addSubview:self.draggableView];
}

- (void)loadLoginButton {
    self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth- 110, 10, 100, 25)];
    [self.loginButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    [self.loginButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.loginButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica Light" size:14]];
    [self.loginButton addTarget:self action:@selector(loginPressed) forControlEvents: UIControlEventTouchUpInside];
}

- (void)loadStartButton {
    self.startButton = [[UIButton alloc] initWithFrame:CGRectMake(screenWidth/2 - 50, screenHeight/2 - 15, 100, 30)];
    [self.startButton setTitle:@"START" forState:UIControlStateNormal];
    [self.startButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.startButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica Light" size:14]];
    [self.startButton addTarget:self action:@selector(startGame) forControlEvents: UIControlEventTouchUpInside];
}

-(void)loadStickFigure {
    self.stickFigureImageView = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth/2-11, 0, 23, 67)];
    self.stickFigureImageView.image = [UIImage imageNamed:@"stickjump.png"];
    self.stickFigureImageView.contentMode = UIViewContentModeScaleToFill;
    //ADD FRAME TO BOTTOM OF SCREEN WHERE USER LOSES IF MAKES CONTACT
    self.bottomOfScreen = [[UIView alloc] initWithFrame: CGRectMake(0, screenHeight-1, screenWidth, 1)];
}

- (void)loadRestart {
    self.retryButton = [[UIButton alloc]initWithFrame:CGRectMake(screenWidth/2 -50, screenHeight/2, 100, 25)];
    [self.retryButton setTitle:@"RETRY" forState:UIControlStateNormal];
    [self.retryButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:15]];
    [self.retryButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.retryButton addTarget:self action:@selector(startGame) forControlEvents:UIControlEventTouchUpInside];
    self.retryButton.hidden = NO;
    [self.view addSubview:self.retryButton];
}

/*-=-=-=-=-=-=-=-=-=-=-=-=START/END GAME METHODS=-=-=-=-=-=-=-=-=-=-=-=-*/
-(void)startGame {
    self.retryButton.hidden = YES;
    [self.stickFigureImageView removeFromSuperview];
    [self loadStickFigure];
    firstTime = YES;
    [self.startButton removeFromSuperview];
    [self.view addSubview:self.stickFigureImageView];
    [self.view addSubview:self.bottomOfScreen];
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    self.scoreLabel.textColor = [UIColor blackColor];
    [self.scoreLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:15]];
    
    UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    //GRAVITY BEHAVIOR
    UIGravityBehavior *gravityBeahvior = [[UIGravityBehavior alloc] initWithItems:@[self.stickFigureImageView]];
    gravityBeahvior.magnitude = .5;
    [animator addBehavior:gravityBeahvior];
    //PUSH BEHAVIOR
    UIPushBehavior *pusher = [[UIPushBehavior alloc] initWithItems:@[self.stickFigureImageView] mode:UIPushBehaviorModeInstantaneous];
    pusher.pushDirection = CGVectorMake(0.5, 0.5);
    pusher.active = YES;
    [animator addBehavior:pusher];
    //COLLISION BEHAVIOR
    UICollisionBehavior *collider = [[UICollisionBehavior alloc] initWithItems:@[self.stickFigureImageView, self.draggableView]];
    collider.collisionDelegate = self;
    collider.collisionMode = UICollisionBehaviorModeEverything;
    collider.translatesReferenceBoundsIntoBoundary = YES;
    [animator addBehavior:collider];
    //TRAMPOLINE BEHAVIOR
    UIDynamicItemBehavior *trampolineBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[self.draggableView]];
    trampolineBehavior.allowsRotation = NO;
    trampolineBehavior.density = 1000.0f;
    [animator addBehavior:trampolineBehavior];
    //STICK FIGURE BEHAVIOR
    UIDynamicItemBehavior *stickFigureBehavior = [[UIDynamicItemBehavior alloc]initWithItems:@[self.stickFigureImageView]];
    stickFigureBehavior.allowsRotation = NO;
    stickFigureBehavior.elasticity = 1.0;
    stickFigureBehavior.friction = 0.0;
    stickFigureBehavior.resistance = 0.0;
    [animator addBehavior:stickFigureBehavior];
    
    
    self.animator = animator;
    self.draggableView.animator = animator;
}

- (void)exitGame {
    score = 0;
    [self loadRestart];
}

/*-=-=-=-=-=-=-=-=-=-=-=-=COLLISION BEHAVIOR DELEGATE=-=-=-=-=-=-=-=-=-=-=-=-*/
- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item withBoundaryIdentifier:(id<NSCopying>)identifier atPoint:(CGPoint)p {
    if (self.stickFigureImageView.frame.origin.y > screenHeight - 97) {
        NSLog(@"ground touched");
        [self.animator removeAllBehaviors];
        self.scoreLabel.textColor = [UIColor redColor];
        [self.scoreLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:23]];
        [self exitGame];
    }
}

- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id<UIDynamicItem>)item1 withItem:(id<UIDynamicItem>)item2 atPoint:(CGPoint)p {
    if ([item1 isEqual:self.stickFigureImageView] && [item2 isEqual:self.draggableView]) {
        score = score + 1;
        self.scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    }
}

/*-=-=-=-=-=-=-=-=-=-=-=-=LOGIN METHODS=-=-=-=-=-=-=-=-=-=-=-=-*/
- (void)loginPressed {
    if ([self.loginButton.titleLabel.text isEqualToString:@"Login"]) {
        self.loginView.hidden = NO;
        self.startButton.hidden = YES;
        self.usernameTextField.text = @"";
        self.passwordTextField.text = @"";
        self.passwordTextField.secureTextEntry = YES;
        if (self.retryButton) {
            self.retryButton.hidden = YES;
        }
    }
}

- (IBAction)loginCancelPressed:(UIButton *)sender {
    self.loginView.hidden = YES;
    self.startButton.hidden = NO;
}

- (IBAction)loginGoPressed:(UIButton *)sender {
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;
    
    if (![username isEqualToString:@""] && ![password isEqualToString:@""]) {   //IF FIELDS ARE NOT EMPTY
        self.loginErrorLabel.text = @" ";
        
        //COMMUNICATE WITH SERVER
        NSURL *url = [NSURL URLWithString:@"http://ec2-54-172-138-236.compute-1.amazonaws.com:8080/LoginAuthentication/LoginCheckApp.jsp"];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        [request setHTTPMethod:@"POST"];
        NSString *params = [NSString stringWithFormat:@"username=%@&password=%@", username, password];
        [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];

        //SEND POST REQUEST
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"[%@]", newStr);
            if ([newStr containsString:@"no"]) {    //IF LOGIN INFORMATION CORRECT
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.loginErrorLabel.text = @"No match.";
                    
                });
            } else if ([newStr containsString:@"yes"]){ //IF LOGIN INFORMATION CORRECT
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.loginView.hidden = YES;
                    [self.loginButton setTitle:[NSString stringWithFormat:@"%@",username] forState:UIControlStateNormal] ;
                    [self.loginButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
                    //self.loginButton.userInteractionEnabled = NO;
                    if (self.retryButton) {
                        self.retryButton.hidden = NO;
                    } else {
                        self.startButton.hidden = NO;
                    }
                });
            } else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.loginErrorLabel.text = @"Problem occurred, please try again later.";
                });
            }
            
        }];
        [task resume];
        
    } else {    //IF FIELDS ARE LEFT EMPTY
        self.loginErrorLabel.text = @"Can't leave fields empty.";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
