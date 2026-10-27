// Every Objective-C framework with an umbrella header on any Apple platform, so the Objective-C grammar knows every name a Cocoa or Cocoa Touch program can reach.
// The generator parses this file once per SDK, and each import is guarded so a framework absent from a platform is skipped there.
// Swift-only frameworks, SwiftUI and the like, have no Objective-C surface and are left out, as are Apple's private underscore frameworks.
// The C frameworks are in includes.c, and what that file reaches is left to the C grammar.
// PCSC is left out because its wintypes.h redefines BOOL.
// CoreHaptics is skipped on macOS, where its headers name AVAudioSession, which does not exist there.
// CoreData, ExtensionKit and PassKit are skipped on watchOS, where their headers name UIKit types that do not exist there.
#include <TargetConditionals.h>
#import <objc/runtime.h>

#if __has_include(<Accessibility/Accessibility.h>)
#import <Accessibility/Accessibility.h>
#endif
#if __has_include(<AccessorySetupKit/AccessorySetupKit.h>)
#import <AccessorySetupKit/AccessorySetupKit.h>
#endif
#if __has_include(<Accounts/Accounts.h>)
#import <Accounts/Accounts.h>
#endif
#if __has_include(<AddressBook/AddressBook.h>)
#import <AddressBook/AddressBook.h>
#endif
#if __has_include(<AddressBook/AddressBookUI.h>)
#import <AddressBook/AddressBookUI.h>
#endif
#if __has_include(<AddressBookUI/AddressBookUI.h>)
#import <AddressBookUI/AddressBookUI.h>
#endif
#if __has_include(<AdServices/AdServices.h>)
#import <AdServices/AdServices.h>
#endif
#if __has_include(<AdSupport/AdSupport.h>)
#import <AdSupport/AdSupport.h>
#endif
#if __has_include(<AppClip/AppClip.h>)
#import <AppClip/AppClip.h>
#endif
#if __has_include(<AppIntents/AppIntents.h>)
#import <AppIntents/AppIntents.h>
#endif
#if __has_include(<AppKit/AppKit.h>)
#import <AppKit/AppKit.h>
#endif
#if __has_include(<AppleScriptObjC/AppleScriptObjC.h>)
#import <AppleScriptObjC/AppleScriptObjC.h>
#endif
#if __has_include(<AppTrackingTransparency/AppTrackingTransparency.h>)
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#endif
#if __has_include(<ARKit/ARKit.h>)
#import <ARKit/ARKit.h>
#endif
#if __has_include(<AssetsLibrary/AssetsLibrary.h>)
#import <AssetsLibrary/AssetsLibrary.h>
#endif
#if __has_include(<AuthenticationServices/AuthenticationServices.h>)
#import <AuthenticationServices/AuthenticationServices.h>
#endif
#if __has_include(<AutomaticAssessmentConfiguration/AutomaticAssessmentConfiguration.h>)
#import <AutomaticAssessmentConfiguration/AutomaticAssessmentConfiguration.h>
#endif
#if __has_include(<Automator/Automator.h>)
#import <Automator/Automator.h>
#endif
#if __has_include(<AVFAudio/AVFAudio.h>)
#import <AVFAudio/AVFAudio.h>
#endif
#if __has_include(<AVFoundation/AVFoundation.h>)
#import <AVFoundation/AVFoundation.h>
#endif
#if __has_include(<AVKit/AVKit.h>)
#import <AVKit/AVKit.h>
#endif
#if __has_include(<AVRouting/AVRouting.h>)
#import <AVRouting/AVRouting.h>
#endif
#if __has_include(<AVSystemRouting/AVSystemRouting.h>)
#import <AVSystemRouting/AVSystemRouting.h>
#endif
#if __has_include(<BackgroundAssets/BackgroundAssets.h>)
#import <BackgroundAssets/BackgroundAssets.h>
#endif
#if __has_include(<BackgroundTasks/BackgroundTasks.h>)
#import <BackgroundTasks/BackgroundTasks.h>
#endif
#if __has_include(<BrowserKit/BrowserKit.h>)
#import <BrowserKit/BrowserKit.h>
#endif
#if __has_include(<BusinessChat/BusinessChat.h>)
#import <BusinessChat/BusinessChat.h>
#endif
#if __has_include(<CalendarStore/CalendarStore.h>)
#import <CalendarStore/CalendarStore.h>
#endif
#if __has_include(<CallKit/CallKit.h>)
#import <CallKit/CallKit.h>
#endif
#if __has_include(<CarPlay/CarPlay.h>)
#import <CarPlay/CarPlay.h>
#endif
#if __has_include(<Cinematic/Cinematic.h>)
#import <Cinematic/Cinematic.h>
#endif
#if __has_include(<ClassKit/ClassKit.h>)
#import <ClassKit/ClassKit.h>
#endif
#if __has_include(<ClockKit/ClockKit.h>)
#import <ClockKit/ClockKit.h>
#endif
#if __has_include(<CloudKit/CloudKit.h>)
#import <CloudKit/CloudKit.h>
#endif
#if __has_include(<Collaboration/Collaboration.h>)
#import <Collaboration/Collaboration.h>
#endif
#if __has_include(<Contacts/Contacts.h>)
#import <Contacts/Contacts.h>
#endif
#if __has_include(<ContactsUI/ContactsUI.h>)
#import <ContactsUI/ContactsUI.h>
#endif
#if __has_include(<CoreAudioKit/CoreAudioKit.h>)
#import <CoreAudioKit/CoreAudioKit.h>
#endif
#if __has_include(<CoreBluetooth/CoreBluetooth.h>)
#import <CoreBluetooth/CoreBluetooth.h>
#endif
#if __has_include(<CoreData/CoreData.h>) && !TARGET_OS_WATCH
#import <CoreData/CoreData.h>
#endif
#if __has_include(<CoreHaptics/CoreHaptics.h>) && !TARGET_OS_OSX
#import <CoreHaptics/CoreHaptics.h>
#endif
#if __has_include(<CoreImage/CoreImage.h>)
#import <CoreImage/CoreImage.h>
#endif
#if __has_include(<CoreLocation/CoreLocation.h>)
#import <CoreLocation/CoreLocation.h>
#endif
#if __has_include(<CoreLocationUI/CoreLocationUI.h>)
#import <CoreLocationUI/CoreLocationUI.h>
#endif
#if __has_include(<CoreMediaIO/CoreMediaIO.h>)
#import <CoreMediaIO/CoreMediaIO.h>
#endif
#if __has_include(<CoreML/CoreML.h>)
#import <CoreML/CoreML.h>
#endif
#if __has_include(<CoreMotion/CoreMotion.h>)
#import <CoreMotion/CoreMotion.h>
#endif
#if __has_include(<CoreNFC/CoreNFC.h>)
#import <CoreNFC/CoreNFC.h>
#endif
#if __has_include(<CoreSpotlight/CoreSpotlight.h>)
#import <CoreSpotlight/CoreSpotlight.h>
#endif
#if __has_include(<CoreWLAN/CoreWLAN.h>)
#import <CoreWLAN/CoreWLAN.h>
#endif
#if __has_include(<CryptoTokenKit/CryptoTokenKit.h>)
#import <CryptoTokenKit/CryptoTokenKit.h>
#endif
#if __has_include(<DataDetection/DataDetection.h>)
#import <DataDetection/DataDetection.h>
#endif
#if __has_include(<DeviceCheck/DeviceCheck.h>)
#import <DeviceCheck/DeviceCheck.h>
#endif
#if __has_include(<DeviceDiscoveryUI/DeviceDiscoveryUI.h>)
#import <DeviceDiscoveryUI/DeviceDiscoveryUI.h>
#endif
#if __has_include(<DiscRecording/DiscRecording.h>)
#import <DiscRecording/DiscRecording.h>
#endif
#if __has_include(<DiscRecordingUI/DiscRecordingUI.h>)
#import <DiscRecordingUI/DiscRecordingUI.h>
#endif
#if __has_include(<EventKit/EventKit.h>)
#import <EventKit/EventKit.h>
#endif
#if __has_include(<EventKitUI/EventKitUI.h>)
#import <EventKitUI/EventKitUI.h>
#endif
#if __has_include(<ExceptionHandling/ExceptionHandling.h>)
#import <ExceptionHandling/ExceptionHandling.h>
#endif
#if __has_include(<ExecutionPolicy/ExecutionPolicy.h>)
#import <ExecutionPolicy/ExecutionPolicy.h>
#endif
#if __has_include(<ExposureNotification/ExposureNotification.h>)
#import <ExposureNotification/ExposureNotification.h>
#endif
#if __has_include(<ExtensionFoundation/ExtensionFoundation.h>)
#import <ExtensionFoundation/ExtensionFoundation.h>
#endif
#if __has_include(<ExtensionKit/ExtensionKit.h>) && !TARGET_OS_WATCH
#import <ExtensionKit/ExtensionKit.h>
#endif
#if __has_include(<ExternalAccessory/ExternalAccessory.h>)
#import <ExternalAccessory/ExternalAccessory.h>
#endif
#if __has_include(<FileProvider/FileProvider.h>)
#import <FileProvider/FileProvider.h>
#endif
#if __has_include(<FileProviderUI/FileProviderUI.h>)
#import <FileProviderUI/FileProviderUI.h>
#endif
#if __has_include(<FinderSync/FinderSync.h>)
#import <FinderSync/FinderSync.h>
#endif
#if __has_include(<Foundation/Foundation.h>)
#import <Foundation/Foundation.h>
#endif
#if __has_include(<GameController/GameController.h>)
#import <GameController/GameController.h>
#endif
#if __has_include(<GameKit/GameKit.h>)
#import <GameKit/GameKit.h>
#endif
#if __has_include(<GameplayKit/GameplayKit.h>)
#import <GameplayKit/GameplayKit.h>
#endif
#if __has_include(<GLKit/GLKit.h>)
#import <GLKit/GLKit.h>
#endif
#if __has_include(<HealthKit/HealthKit.h>)
#import <HealthKit/HealthKit.h>
#endif
#if __has_include(<HealthKitUI/HealthKitUI.h>)
#import <HealthKitUI/HealthKitUI.h>
#endif
#if __has_include(<HomeKit/HomeKit.h>)
#import <HomeKit/HomeKit.h>
#endif
#if __has_include(<iAd/iAd.h>)
#import <iAd/iAd.h>
#endif
#if __has_include(<ICADevices/ICADevices.h>)
#import <ICADevices/ICADevices.h>
#endif
#if __has_include(<IdentityLookup/IdentityLookup.h>)
#import <IdentityLookup/IdentityLookup.h>
#endif
#if __has_include(<IdentityLookupUI/IdentityLookupUI.h>)
#import <IdentityLookupUI/IdentityLookupUI.h>
#endif
#if __has_include(<ImageCaptureCore/ImageCaptureCore.h>)
#import <ImageCaptureCore/ImageCaptureCore.h>
#endif
#if __has_include(<InputMethodKit/InputMethodKit.h>)
#import <InputMethodKit/InputMethodKit.h>
#endif
#if __has_include(<InstallerPlugins/InstallerPlugins.h>)
#import <InstallerPlugins/InstallerPlugins.h>
#endif
#if __has_include(<Intents/Intents.h>)
#import <Intents/Intents.h>
#endif
#if __has_include(<IntentsUI/IntentsUI.h>)
#import <IntentsUI/IntentsUI.h>
#endif
#if __has_include(<IOBluetooth/IOBluetooth.h>)
#import <IOBluetooth/IOBluetooth.h>
#endif
#if __has_include(<IOBluetoothUI/IOBluetoothUI.h>)
#import <IOBluetoothUI/IOBluetoothUI.h>
#endif
#if __has_include(<IOUSBHost/IOUSBHost.h>)
#import <IOUSBHost/IOUSBHost.h>
#endif
#if __has_include(<iTunesLibrary/iTunesLibrary.h>)
#import <iTunesLibrary/iTunesLibrary.h>
#endif
#if __has_include(<LinkPresentation/LinkPresentation.h>)
#import <LinkPresentation/LinkPresentation.h>
#endif
#if __has_include(<LocalAuthentication/LocalAuthentication.h>)
#import <LocalAuthentication/LocalAuthentication.h>
#endif
#if __has_include(<LocalAuthenticationEmbeddedUI/LocalAuthenticationEmbeddedUI.h>)
#import <LocalAuthenticationEmbeddedUI/LocalAuthenticationEmbeddedUI.h>
#endif
#if __has_include(<MailKit/MailKit.h>)
#import <MailKit/MailKit.h>
#endif
#if __has_include(<MapKit/MapKit.h>)
#import <MapKit/MapKit.h>
#endif
#if __has_include(<Matter/Matter.h>)
#import <Matter/Matter.h>
#endif
#if __has_include(<MatterSupport/MatterSupport.h>)
#import <MatterSupport/MatterSupport.h>
#endif
#if __has_include(<MediaAccessibility/MediaAccessibility.h>)
#import <MediaAccessibility/MediaAccessibility.h>
#endif
#if __has_include(<MediaExtension/MediaExtension.h>)
#import <MediaExtension/MediaExtension.h>
#endif
#if __has_include(<MediaLibrary/MediaLibrary.h>)
#import <MediaLibrary/MediaLibrary.h>
#endif
#if __has_include(<MediaPlayer/MediaPlayer.h>)
#import <MediaPlayer/MediaPlayer.h>
#endif
#if __has_include(<MediaSetup/MediaSetup.h>)
#import <MediaSetup/MediaSetup.h>
#endif
#if __has_include(<Messages/Messages.h>)
#import <Messages/Messages.h>
#endif
#if __has_include(<MessageUI/MessageUI.h>)
#import <MessageUI/MessageUI.h>
#endif
#if __has_include(<Metal/Metal.h>)
#import <Metal/Metal.h>
#endif
#if __has_include(<MetalFX/MetalFX.h>)
#import <MetalFX/MetalFX.h>
#endif
#if __has_include(<MetalKit/MetalKit.h>)
#import <MetalKit/MetalKit.h>
#endif
#if __has_include(<MetalPerformanceShaders/MetalPerformanceShaders.h>)
#import <MetalPerformanceShaders/MetalPerformanceShaders.h>
#endif
#if __has_include(<MetalPerformanceShadersGraph/MetalPerformanceShadersGraph.h>)
#import <MetalPerformanceShadersGraph/MetalPerformanceShadersGraph.h>
#endif
#if __has_include(<MetricKit/MetricKit.h>)
#import <MetricKit/MetricKit.h>
#endif
#if __has_include(<MLCompute/MLCompute.h>)
#import <MLCompute/MLCompute.h>
#endif
#if __has_include(<ModelIO/ModelIO.h>)
#import <ModelIO/ModelIO.h>
#endif
#if __has_include(<MultipeerConnectivity/MultipeerConnectivity.h>)
#import <MultipeerConnectivity/MultipeerConnectivity.h>
#endif
#if __has_include(<NaturalLanguage/NaturalLanguage.h>)
#import <NaturalLanguage/NaturalLanguage.h>
#endif
#if __has_include(<NearbyInteraction/NearbyInteraction.h>)
#import <NearbyInteraction/NearbyInteraction.h>
#endif
#if __has_include(<NetworkExtension/NetworkExtension.h>)
#import <NetworkExtension/NetworkExtension.h>
#endif
#if __has_include(<NotificationCenter/NotificationCenter.h>)
#import <NotificationCenter/NotificationCenter.h>
#endif
#if __has_include(<OSAKit/OSAKit.h>)
#import <OSAKit/OSAKit.h>
#endif
#if __has_include(<OSLog/OSLog.h>)
#import <OSLog/OSLog.h>
#endif
#if __has_include(<ParavirtualizedGraphics/ParavirtualizedGraphics.h>)
#import <ParavirtualizedGraphics/ParavirtualizedGraphics.h>
#endif
#if __has_include(<PassKit/PassKit.h>) && !TARGET_OS_WATCH
#import <PassKit/PassKit.h>
#endif
#if __has_include(<PDFKit/PDFKit.h>)
#import <PDFKit/PDFKit.h>
#endif
#if __has_include(<PencilKit/PencilKit.h>)
#import <PencilKit/PencilKit.h>
#endif
#if __has_include(<PHASE/PHASE.h>)
#import <PHASE/PHASE.h>
#endif
#if __has_include(<Photos/Photos.h>)
#import <Photos/Photos.h>
#endif
#if __has_include(<PhotosUI/PhotosUI.h>)
#import <PhotosUI/PhotosUI.h>
#endif
#if __has_include(<PreferencePanes/PreferencePanes.h>)
#import <PreferencePanes/PreferencePanes.h>
#endif
#if __has_include(<PushKit/PushKit.h>)
#import <PushKit/PushKit.h>
#endif
#if __has_include(<Quartz/Quartz.h>)
#import <Quartz/Quartz.h>
#endif
#if __has_include(<QuartzCore/QuartzCore.h>)
#import <QuartzCore/QuartzCore.h>
#endif
#if __has_include(<QuickLookThumbnailing/QuickLookThumbnailing.h>)
#import <QuickLookThumbnailing/QuickLookThumbnailing.h>
#endif
#if __has_include(<QuickLookUI/QuickLookUI.h>)
#import <QuickLookUI/QuickLookUI.h>
#endif
#if __has_include(<RealityKit/RealityKit.h>)
#import <RealityKit/RealityKit.h>
#endif
#if __has_include(<ReplayKit/ReplayKit.h>)
#import <ReplayKit/ReplayKit.h>
#endif
#if __has_include(<SafariServices/SafariServices.h>)
#import <SafariServices/SafariServices.h>
#endif
#if __has_include(<SafetyKit/SafetyKit.h>)
#import <SafetyKit/SafetyKit.h>
#endif
#if __has_include(<SceneKit/SceneKit.h>)
#import <SceneKit/SceneKit.h>
#endif
#if __has_include(<ScreenCaptureKit/ScreenCaptureKit.h>)
#import <ScreenCaptureKit/ScreenCaptureKit.h>
#endif
#if __has_include(<ScreenSaver/ScreenSaver.h>)
#import <ScreenSaver/ScreenSaver.h>
#endif
#if __has_include(<ScreenTime/ScreenTime.h>)
#import <ScreenTime/ScreenTime.h>
#endif
#if __has_include(<ScriptingBridge/ScriptingBridge.h>)
#import <ScriptingBridge/ScriptingBridge.h>
#endif
#if __has_include(<SecurityFoundation/SecurityFoundation.h>)
#import <SecurityFoundation/SecurityFoundation.h>
#endif
#if __has_include(<SecurityInterface/SecurityInterface.h>)
#import <SecurityInterface/SecurityInterface.h>
#endif
#if __has_include(<SensitiveContentAnalysis/SensitiveContentAnalysis.h>)
#import <SensitiveContentAnalysis/SensitiveContentAnalysis.h>
#endif
#if __has_include(<SensorKit/SensorKit.h>)
#import <SensorKit/SensorKit.h>
#endif
#if __has_include(<ServiceManagement/ServiceManagement.h>)
#import <ServiceManagement/ServiceManagement.h>
#endif
#if __has_include(<SharedWithYou/SharedWithYou.h>)
#import <SharedWithYou/SharedWithYou.h>
#endif
#if __has_include(<SharedWithYouCore/SharedWithYouCore.h>)
#import <SharedWithYouCore/SharedWithYouCore.h>
#endif
#if __has_include(<ShazamKit/ShazamKit.h>)
#import <ShazamKit/ShazamKit.h>
#endif
#if __has_include(<Social/Social.h>)
#import <Social/Social.h>
#endif
#if __has_include(<SoundAnalysis/SoundAnalysis.h>)
#import <SoundAnalysis/SoundAnalysis.h>
#endif
#if __has_include(<Speech/Speech.h>)
#import <Speech/Speech.h>
#endif
#if __has_include(<SpriteKit/SpriteKit.h>)
#import <SpriteKit/SpriteKit.h>
#endif
#if __has_include(<StoreKit/StoreKit.h>)
#import <StoreKit/StoreKit.h>
#endif
#if __has_include(<Symbols/Symbols.h>)
#import <Symbols/Symbols.h>
#endif
#if __has_include(<SyncServices/SyncServices.h>)
#import <SyncServices/SyncServices.h>
#endif
#if __has_include(<SystemExtensions/SystemExtensions.h>)
#import <SystemExtensions/SystemExtensions.h>
#endif
#if __has_include(<ThreadNetwork/ThreadNetwork.h>)
#import <ThreadNetwork/ThreadNetwork.h>
#endif
#if __has_include(<TouchController/TouchController.h>)
#import <TouchController/TouchController.h>
#endif
#if __has_include(<Translation/Translation.h>)
#import <Translation/Translation.h>
#endif
#if __has_include(<TVMLKit/TVMLKit.h>)
#import <TVMLKit/TVMLKit.h>
#endif
#if __has_include(<TVServices/TVServices.h>)
#import <TVServices/TVServices.h>
#endif
#if __has_include(<TVUIKit/TVUIKit.h>)
#import <TVUIKit/TVUIKit.h>
#endif
#if __has_include(<Twitter/Twitter.h>)
#import <Twitter/Twitter.h>
#endif
#if __has_include(<UIKit/UIKit.h>)
#import <UIKit/UIKit.h>
#endif
#if __has_include(<UniformTypeIdentifiers/UniformTypeIdentifiers.h>)
#import <UniformTypeIdentifiers/UniformTypeIdentifiers.h>
#endif
#if __has_include(<UserNotifications/UserNotifications.h>)
#import <UserNotifications/UserNotifications.h>
#endif
#if __has_include(<UserNotificationsUI/UserNotificationsUI.h>)
#import <UserNotificationsUI/UserNotificationsUI.h>
#endif
#if __has_include(<VideoSubscriberAccount/VideoSubscriberAccount.h>)
#import <VideoSubscriberAccount/VideoSubscriberAccount.h>
#endif
#if __has_include(<Virtualization/Virtualization.h>)
#import <Virtualization/Virtualization.h>
#endif
#if __has_include(<Vision/Vision.h>)
#import <Vision/Vision.h>
#endif
#if __has_include(<WatchConnectivity/WatchConnectivity.h>)
#import <WatchConnectivity/WatchConnectivity.h>
#endif
#if __has_include(<WatchKit/WatchKit.h>)
#import <WatchKit/WatchKit.h>
#endif
#if __has_include(<WebKit/WebKit.h>)
#import <WebKit/WebKit.h>
#endif
#if __has_include(<WidgetKit/WidgetKit.h>)
#import <WidgetKit/WidgetKit.h>
#endif

int main (int argc, char const* argv[])
{
	return 0;
}
