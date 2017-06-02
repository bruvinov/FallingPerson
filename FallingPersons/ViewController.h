//
//  ViewController.h
//  FallingPersons
//
//  Created by Boris Ruvinov on 3/30/16.
//  Copyright © 2016 Boris Ruvinov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraggableView.h"


@interface ViewController : UIViewController <UICollisionBehaviorDelegate, UIDynamicAnimatorDelegate>

@property (nonatomic, strong) UIButton *startButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIImageView *stickFigureImageView;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) DraggableView *draggableView;
@property (nonatomic, strong) UIView *bottomOfScreen;
@property (nonatomic, strong) UILabel *scoreLabel;
@property (nonatomic, strong) UIButton *retryButton;
@property (strong, nonatomic) IBOutlet UIView *loginView;
@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UILabel *loginErrorLabel;

@end

