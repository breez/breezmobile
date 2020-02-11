import UIKit
import CoreFoundation

UserDefaults.standard.setValue("en_US", forKey: "AppleLocale");
UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv,
                  NSStringFromClass(UIApplication.self), NSStringFromClass(AppDelegate.self))
