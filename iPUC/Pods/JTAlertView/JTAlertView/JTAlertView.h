//
//  JTAlertView.h
//
//  Created by Jakub Truhlar on 07.06.15.
//  Copyright (c) 2015 Jakub Truhlar. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JTAlertView : UIView

/** In Cancel and Destructive case JTAlertView will try to use bold version of your font (Must be in format FontName-Bold) */
typedef NS_ENUM(NSInteger, JTAlertViewStyle) {
    JTAlertViewStyleDefault = 0,
    JTAlertViewStyleCancel,
    JTAlertViewStyleDestructive
};

typedef void (^JTAlertViewStyling)(UIButton *btn);

// Public properties
/** Size of the alertView. Default is 240.0, 290.0. */
@property (nonatomic, assign) CGSize size;

/** Pop animation of the alertView when shows and pressed (Disable animated show will also disable pop show animation). Default is YES. */
@property (nonatomic, assign, getter=isPopAnimation) bool popAnimation;

/** Beautiful parallax effect of image within alertView. Default is YES. */
@property (nonatomic, assign, getter=isParallaxEffect) bool parallaxEffect;

/** Image overlay. Default overlay is gray with half alpha. */
@property (nonatomic, strong) UIColor *overlayColor;

/** Button separator color. Default is 97% white. */
@property (nonatomic, strong) UIColor *separatorColor;

/** Font applied on title and alertView buttons. AlertView buttons will ignore this font's size but not the style (In case you want to setup custom font for your buttons, use font parameter in method instead). Default is Helvetica Neue Medium with 21.0 size. */
@property (nonatomic, strong) UIFont *font;

/** Color of the alertView's title. Default is white. */
@property (nonatomic, strong) UIColor *titleColor;

/** Shadow underneath the title. Default is YES. */
@property (nonatomic, assign, getter=isTitleShadow) bool titleShadow;

/** Shadow underneath the alertView. Default is NO. */
@property (nonatomic, assign, getter=isBackgroundShadow) bool backgroundShadow;

// Initializers
+ (instancetype)alertWithTitle:(NSString * _Nullable)titleText andImage:(UIImage * _Nullable)image;
- (instancetype)initWithTitle:(NSString * _Nullable)titleText andImage:(UIImage * _Nullable)image;

// Buttons
- (void)addButtonWithTitle:(NSString *)titleText action:(void (^)(JTAlertView *alertView))action;
- (void)addButtonWithTitle:(NSString *)titleText style:(JTAlertViewStyle)style action:(void (^)(JTAlertView *alertView))action;
- (void)addButtonWithTitle:(NSString *)titleText style:(JTAlertViewStyle)style forControlEvents:(UIControlEvents)controlEvents action:(void (^)(JTAlertView *alertView))action;
- (void)addButtonWithTitle:(NSString *)titleText font:(UIFont * _Nullable)font style:(JTAlertViewStyle)style forControlEvents:(UIControlEvents)controlEvents action:(void (^)(JTAlertView *alertView))action;

/** Designated method to adda a button. Provide a styling block to update custom styling to provided button, overriding default JTAlertViewStyle parameter and font. */
- (void)addButtonWithTitle:(NSString *)titleText styling:(JTAlertViewStyling _Nullable)styling forControlEvents:(UIControlEvents)controlEvents action:(void (^)(JTAlertView *alertView))action;

// Displaying
- (void)show;
- (void)showInSuperview:(UIView *)superView withCompletion:(void (^ _Nullable)())completion animated:(bool)animated;
- (void)hide;
- (void)hideWithCompletion:( void (^ _Nullable )())completion animated:(bool)animated;
- (void)hideWithDelay:(NSTimeInterval)delay animated:(bool)animated;

@end

// UIButton Subclass
@interface UIBlockButton : UIButton

typedef void (^ActionBlock)(JTAlertView *alertView);
@property (nonatomic, strong) ActionBlock actionBlock;

- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)action;

@end

NS_ASSUME_NONNULL_END
