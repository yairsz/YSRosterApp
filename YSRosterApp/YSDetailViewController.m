//
//  YSDetailViewController.m
//  YSRosterApp
//
//  Created by Yair Szarf on 1/13/14.
//  Copyright (c) 2014 The 2 Handed Consortium. All rights reserved.
//

#import "YSDetailViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface YSDetailViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *faceImageView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *twitterTextField;
@property (weak, nonatomic) IBOutlet UITextField *githubTextField;
@property (weak, nonatomic) IBOutlet UILabel *photoMessageLabel;

@property BOOL isEditingText;

@end

@implementation YSDetailViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.nameTextField.text = self.selectedPerson.name;
    self.twitterTextField.text = self.selectedPerson.twitter;
    self.githubTextField.text = self.selectedPerson.github;
    self.faceImageView.image = [UIImage imageWithContentsOfFile:self.selectedPerson.imagePath];
    
    //turn the image into a circle
    self.faceImageView.layer.cornerRadius = self.faceImageView.bounds.size.width / 2;
    self.faceImageView.clipsToBounds = YES;
    self.isEditingText = NO;
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIActionSheetDelegate

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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if (!self.isEditingText){
    //move the view up so we can see the text fields we are editing
    [UIView animateWithDuration:0.4 animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y - 210.f, self.view.frame.size.width, self.view.frame.size.height);
    }];
    }
    //This bool is set because touching another textfield will make the view jump unnecesarily
    self.isEditingText = YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    //move the view down to its normal state
    [UIView animateWithDuration:0.4 animations:^{
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y + 210.f, self.view.frame.size.width, self.view.frame.size.height);
    }];
    if (textField == self.twitterTextField) {
        self.selectedPerson.twitter = textField.text;
        
    } else if (textField ==self.githubTextField) {
        self.selectedPerson.github = textField.text;
    }
    self.isEditingText = NO;
    [self.dataSource saveData];
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
