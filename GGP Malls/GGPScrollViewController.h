//
//  GGPScrollViewController.h
//  GGP Malls
//
//  Created by Christiaan Kuilman on 3/29/16.
//  Copyright © 2016 GGP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGPScrollViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;

@end
