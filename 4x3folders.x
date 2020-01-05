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
if (![NSProcessInfo processInfo]) return;
  NSString *processName = [NSProcessInfo processInfo].processName;
  bool isSpringboard = [@"SpringBoard" isEqualToString:processName];

  // Someone smarter than Nepeta invented this.
  // https://www.reddit.com/r/jailbreak/comments/4yz5v5/questionremote_messages_not_enabling/d6rlh88/
  bool shouldLoad = NO;
  NSArray *args = [[NSClassFromString(@"NSProcessInfo") processInfo] arguments];
  NSUInteger count = args.count;
  if (count != 0) {
      NSString *executablePath = args[0];
      if (executablePath) {
          NSString *processName = [executablePath lastPathComponent];
          BOOL isApplication = [executablePath rangeOfString:@"/Application/"].location != NSNotFound || [executablePath rangeOfString:@"/Applications/"].location != NSNotFound;
          BOOL isFileProvider = [[processName lowercaseString] rangeOfString:@"fileprovider"].location != NSNotFound;
          BOOL skip = [processName isEqualToString:@"AdSheet"]
                      || [processName isEqualToString:@"CoreAuthUI"]
                      || [processName isEqualToString:@"InCallService"]
                      || [processName isEqualToString:@"MessagesNotificationViewService"]
                      || [executablePath rangeOfString:@".appex/"].location != NSNotFound;
          if ((!isFileProvider && isApplication && !skip) || isSpringboard) {
              shouldLoad = YES;
          }
      }
  }

  if (!shouldLoad) return;

  dpkgInvalid = ![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.burritoz.4x3folders.list"];
  if (!dpkgInvalid) dpkgInvalid = ![[NSFileManager defaultManager] fileExistsAtPath:@"/var/lib/dpkg/info/com.burritoz.4x3folders.md5sums"];
}
