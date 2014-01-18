//
//  YSDetailViewController.m
//  YSRosterApp
//
//  Created by Yair Szarf on 1/13/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import "YSScrollViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface YSScrollViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *twitterTextField;
@property (weak, nonatomic) IBOutlet UITextField *githubTextField;
@property (weak, nonatomic) IBOutlet UILabel *photoMessageLabel;
@property (weak, nonatomic) IBOutlet UIView *slidersView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIButton *pinWheelButton;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *photoGR;

@property (weak, nonatomic) UITextField * activeField;

@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;

@property float redValue;
@property float greenValue;
@property float blueValue;

@end

@implementation YSScrollViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.nameTextField.text = self.selectedPerson.name;
    self.twitterTextField.text = self.selectedPerson.twitter;
    self.githubTextField.text = self.selectedPerson.github;
    if (self.selectedPerson.imagePath) {
        self.faceImageView.image = [UIImage imageWithContentsOfFile:self.selectedPerson.imagePath];
        self.photoMessageLabel.hidden = YES;
    }
    
    [self.nameTextField setEnabled:NO];
    
    [self hideSlidersView];
    
    self.title = self.selectedPerson.name;
    
    //set background color from selected user
    self.redValue = [(NSNumber *)self.selectedPerson.rgbValues[0] floatValue];
    self.greenValue = [(NSNumber *)self.selectedPerson.rgbValues[1] floatValue];
    self.blueValue = [(NSNumber *)self.selectedPerson.rgbValues[2] floatValue];
    [self updateBackgroundColor];
    
    //turn the image into a circle
    self.faceImageView.layer.cornerRadius = self.faceImageView.bounds.size.width / 2;
    self.faceImageView.clipsToBounds = YES;

    //Run the Notification setup for the keyboard show
    [self registerForKeyboardNotifications];
    
    self.scrollView.scrollEnabled = NO;
    
}

- (void) viewWillLayoutSubviews {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
}

- (void) viewWillDisappear:(BOOL)animated {
    NSArray * rgbValues = @[[NSNumber numberWithFloat:self.redValue],
                            [NSNumber numberWithFloat:self.greenValue],
                            [NSNumber numberWithFloat:self.blueValue]];
    self.selectedPerson.rgbValues = rgbValues;
    [self.dataSource saveData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeShown:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - IBActions

- (IBAction) doubleTapFace:(id)sender {
    
    //handles the double tap gesture recognizer target action
    self.photoMessageLabel.hidden = YES;
    
    //check availability of camera
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //present an action sheet allowing the user to choose either to take a picture or choose from library
        UIActionSheet * mySheet;
        mySheet = [[UIActionSheet alloc] initWithTitle:@"Set Image"
                                              delegate:self
                                     cancelButtonTitle:@"Cancel"
                                destructiveButtonTitle:Nil
                                     otherButtonTitles:@"Camera",@"Choose Photo", nil];
        [mySheet showInView:self.view];
    } else {
        // if camera is not available, user may only pick image from library
        NSString * message = @"Only images from your library will be avaialable";
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"No Camera!" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Cool",nil];
        [alertView show];
        
    }
}

- (IBAction)tapColorWheel:(UIButton *)sender {
    self.slidersView.hidden = NO;
    [self showSlidersView];
    
}
- (IBAction)tapDoneSlidersButton:(UIButton *)sender {
    [self hideSlidersView];
    NSArray * rgbValues = @[[NSNumber numberWithFloat:self.redValue],
                            [NSNumber numberWithFloat:self.greenValue],
                            [NSNumber numberWithFloat:self.blueValue]];
    self.selectedPerson.rgbValues = rgbValues;
    [self.dataSource saveData];
}


-(void) hideSlidersView {
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    //wait a second before hiding the sliders view credit http://stackoverflow.com/users/2087165/despotovic
    double delayInSeconds = 0.5f;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.slidersView.hidden = YES;
    });
}

-(void) showSlidersView {
    [self.scrollView setContentOffset:CGPointMake(0, 0 + self.slidersView.frame.size.height) animated:YES];
    self.scrollView.scrollEnabled = NO;
}

- (IBAction)redSliderChanged:(UISlider *)sender {
    self.redValue = sender.value;
    [self updateBackgroundColor];
}

- (IBAction)greenSliderChanged:(UISlider *)sender {
    self.greenValue = sender.value;
    [self updateBackgroundColor];
}

- (IBAction)blueSliderChanged:(UISlider *)sender {
    self.blueValue = sender.value;
    [self updateBackgroundColor];
}

- (void) updateBackgroundColor
{
    self.view.backgroundColor = [UIColor colorWithRed:self.redValue green:self.greenValue blue:self.blueValue alpha:1];
    //reverse colors for text
    UIColor * reverseColor = [UIColor colorWithRed:1-self.redValue green:1-self.greenValue blue:1-self.blueValue alpha:1];
    self.nameTextField.textColor = reverseColor;
    self.twitterTextField.textColor = reverseColor;
    self.githubTextField.textColor = reverseColor;
    self.twitterTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Twitter" attributes:@{NSForegroundColorAttributeName: reverseColor}];
    self.githubTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Github" attributes:@{NSForegroundColorAttributeName: reverseColor}];
    [self.doneButton setTitleColor:reverseColor forState:UIControlStateNormal];
    
}
#pragma mark - UIActionSheetDelegate

-(void) actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    UIImagePickerController * myPicker = [[UIImagePickerController alloc] init];
    myPicker.delegate = self;
    myPicker.allowsEditing = YES;
    
    
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Camera"]) {
        myPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Choose Photo"]) {
        
        //check for authorization status
        if ([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied || [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted) {
            //if access to library is restricted display alert view
            NSString * message = @"You must authorize RosterApp to access your image library in Settings>Privacy>Photos";
            UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"Permission Denied!" message:message delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
            [alertView show];
            
            //reset the message on top of the image view
            self.photoMessageLabel.hidden = NO;
        } else {
            myPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    } else {
        self.photoMessageLabel.hidden = NO;
        return;
    }
    [self presentViewController:myPicker animated:YES completion:^{
        
    }];
}

#pragma mark - UIAlertViewDelegate

-(void) alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //This action sheet is presented after the user is alerted that only images from library are available
        UIActionSheet * mySheet;
        mySheet = [[UIActionSheet alloc] initWithTitle:@"Set Image"
                                              delegate:self
                                     cancelButtonTitle:@"Cancel"
                                destructiveButtonTitle:Nil
                                     otherButtonTitles:@"Choose Photo", nil];
        [mySheet showInView:self.view];
    }
}

#pragma mark - UIImagePickerControllerDelegate

-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:^{
        
        UIImage * editedImage =[info objectForKey:UIImagePickerControllerEditedImage]; //get image
        self.faceImageView.image = editedImage; //Display it in the detail view
        
        [self saveImageToSelectedPerson:editedImage];
    }];
}


- (void) saveImageToSelectedPerson:(UIImage *) image
{
    //This next block is used to save image in users document directory
    NSData * imageData = UIImageJPEGRepresentation(image,0.5);
    NSString * fileName = [NSString stringWithFormat:@"%@.jpg",self.selectedPerson.name];
    NSString * filePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:fileName];
    [imageData writeToFile:filePath atomically:YES];
    
    //Set reference in data source and save it
    self.selectedPerson.imagePath = filePath;
    [self.dataSource saveData];
}

- (NSString *) applicationDocumentsDirectory
{
    NSURL * docsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    return [docsURL path];
}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    self.activeField = nil;
    
    if (textField == self.twitterTextField) {
//        NSString *text;
//        if ([textField.text hasPrefix:@"@"]){
//            text = textField.text;
//        } else if (textField.text.length > 0){
//            text = [NSString stringWithFormat:@"%@",textField.text];
//        }
        self.selectedPerson.twitter = textField.text;
        
    } else if (textField == self.githubTextField) {
        NSString *text;
        if ([textField.text hasPrefix:@"http://github.com/"]){
            text = textField.text;
        } else if (textField.text.length > 0){
            text = [NSString stringWithFormat:@"http://github.com/%@",textField.text];
        }
        self.selectedPerson.github = text;
        textField.text = text;
    }
    [self.dataSource saveData];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWillBeShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //scroll so textviews are visible
    [self.scrollView setContentOffset:CGPointMake(0, 0 + kbSize.height) animated:YES];
    
    self.pinWheelButton.enabled = NO;
    self.photoGR.enabled = NO;
    self.scrollView.scrollEnabled = NO;
    
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    self.pinWheelButton.enabled = YES;
    self.photoGR.enabled = YES;
    
}

- (BOOL) canBecomeFirstResponder {
    return NO;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
//This is a gist by @johnnyclem https://gist.github.com/johnnyclem/8215415 well done!
    for (UIControl *control in self.view.subviews) {
        if ([control isKindOfClass:[UITextField class]]) {
            [control endEditing:YES];
        }
    }
}

@end
