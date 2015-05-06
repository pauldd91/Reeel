//
//  RSVPDetailViewController.m
//  
//
//  Created by Collin Grubbs on 5/2/15.
//
//

#import "RSVPDetailViewController.h"
#import "ScreeningStore.h"

@interface RSVPDetailViewController () <UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *userEmailLabel;
@property (weak, nonatomic) IBOutlet UITextField *guestsLabel;

@property (weak, nonatomic) IBOutlet UILabel *termsLabel;
@property (retain, nonatomic) IBOutlet UISwitch *termsSwitch;
@property (retain, nonatomic) IBOutlet UIButton *confirmButton;

@property (nonatomic, assign) id currentResponder;


@end

@implementation RSVPDetailViewController 

@synthesize userNameLabel;
@synthesize userEmailLabel;
@synthesize guestsLabel;
@synthesize termsLabel;
@synthesize termsSwitch;
@synthesize confirmButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    userNameLabel.text = [defaults objectForKey:@"userName"];
    userEmailLabel.text = [defaults objectForKey:@"userEmail"];
    guestsLabel.text = @"Number of guests";
    termsLabel.text = @"Agree to Terms and Conditions";
    
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveUserData:) name:UIKeyboardDidHideNotification object:nil];


    
    // Do any additional setup after loading the view from its nib.
    // Set background color of view
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"RSVP";
    
    // remove keyboard with outside touch
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignOnTap:)];
    [singleTap setNumberOfTapsRequired:1];
    [singleTap setNumberOfTouchesRequired:1];
    [self.view addGestureRecognizer:singleTap];
    //[singleTap release];
    
}

// confirmButton press action
//**********************************
- (IBAction)RSVPButtonPressed:(UIButton *)sender {
    
    Screening *screening = self.screening;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thank You" message:@"Your RSVP has been confirmed." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    
    //  call rsvpForScreening method here
    [[ScreeningStore sharedStore] rsvpForScreening:screening];
    
    
    [alert show];
    
    
}
//**********************************

// check to see if text field is in the format of an email, triggers an alert if it is not
- (void)checkEmailAndDisplayAlert {
    if(![self validateEmail:[userEmailLabel text]]) {
        // user entered invalid email address
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter a valid email address." delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        //[alert release];
    } else {
        // user entered valid email address
    }
}

// check to determine whether a text field is a valid email
- (BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

// restrict keyboard selection to non-zero integers for guests label
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == guestsLabel) {
        NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"123456789"] invertedSet];
        if ([string stringByTrimmingCharactersInSet:nonNumberSet].length > 0)return YES;
        if (!string.length)return YES;

        return NO;
    }
    else {
        return YES;
    }
    
}

// keyboard removal through touch outside keyboard
- (void)resignOnTap:(id)iSender {
    [self.currentResponder resignFirstResponder];
}

// assist keyboard removal by identifying first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    self.currentResponder = textField;
}


// hide keyboard on return key
-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    return YES;
}

// terms and conditions must be accepted, all fields completed correctly before confirmation enabled. specific warnings on exit of uncompleted fields
- (IBAction) toggleEnabledConfirmButton: (id) sender {
    if (sender == guestsLabel) {
        if ((!guestsLabel.text.length > 0) && (![guestsLabel.text intValue] > 0)) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter a valid number of guests" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }
    if (sender == userNameLabel) {
        if (!userNameLabel.text.length > 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Enter a valid name" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }
    }
    if (sender == userEmailLabel) {
        [self checkEmailAndDisplayAlert];
    }
    if ((termsSwitch.on) && (guestsLabel.text.length > 0) && (userEmailLabel.text.length > 0) && (userNameLabel.text.length > 0) && [self validateEmail:[userEmailLabel text]] && ([guestsLabel.text intValue] > 0)) {
        confirmButton.enabled = YES;
    }
    else {
        confirmButton.enabled = NO;
    }
    }


// data persistence
- (void)saveUserData: (NSNotification *)notify
{
    [userNameLabel resignFirstResponder];
    [userEmailLabel resignFirstResponder];
    [guestsLabel resignFirstResponder];
    
    NSString *userName = [userNameLabel text];
    NSString *userEmail = [userEmailLabel text];
    //NSString *guests = [guestsLabel text];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:userName forKey:@"userName"];
    [defaults setObject:userEmail forKey:@"userEmail"];
    [defaults synchronize];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end