//I needed more room in my folders so here it is...
//piracy protection
@interface SBCoverSheetPrimarySlidingViewController : UIViewController
- (void)viewDidDisappear:(BOOL)arg1;
- (void)viewDidAppear:(BOOL)arg1;
@end
BOOL dpkgInvalid = NO;
%hook SBCoverSheetPrimarySlidingViewController
- (void)viewDidDisappear:(BOOL)arg1 {

    %orig; //  Thanks to Nepeta for the DRM
    if (!dpkgInvalid) return;
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Pirate Detected!"
		message:@"Seriously? Pirating a free Tweak is awful!\nPiracy repo's Tweaks could contain Malware if you didn't know that, so go ahead and get 4x3Folders from the official Source https://Burrit0z.github.io/repo/.\nIf you're seeing this but you got it from the official source then make sure to add https://Burrit0z.github.io/repo to Cydia or Sileo."
		preferredStyle:UIAlertControllerStyleAlert];

		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {

			UIApplication *application = [UIApplication sharedApplication];
			[application openURL:[NSURL URLWithString:@"https://Burrit0z.github.io/repo"] options:@{} completionHandler:nil];

	}];
    [alertController addAction:cancelAction];
		[self presentViewController:alertController animated:YES completion:nil];

}
%end
//ios 13
%hook SBIconListFlowLayout
- (NSUInteger)numberOfColumnsForOrientation:(NSInteger)arg1 {
  return 4;
}
%end
//ios 12 and lower
%hook SBFolderIconListView
+(unsigned long long)iconColumnsForInterfaceOrientation:(long long)arg1 {
  return (4);
}
%end
%ctor {
  dpkgInvalid = ![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.burritoz.4x3folders.list"];
  if (!dpkgInvalid) dpkgInvalid = ![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.burritoz.4x3folders.md5sums"];
}
