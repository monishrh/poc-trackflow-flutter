#import "FlutterTrackflowPlugin.h"
#if __has_include(<flutter_trackflow/flutter_trackflow-Swift.h>)
#import <flutter_trackflow/flutter_trackflow-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_trackflow-Swift.h"
#endif

@implementation FlutterTrackflowPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterTrackflowPlugin registerWithRegistrar:registrar];
}
@end
