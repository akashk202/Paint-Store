# Sceneform missing classes
-dontwarn com.google.ar.sceneform.animation.AnimationEngine
-dontwarn com.google.ar.sceneform.animation.AnimationLibraryLoader
-dontwarn com.google.ar.sceneform.assets.Loader
-dontwarn com.google.ar.sceneform.assets.ModelData

# Desugar missing classes
-dontwarn com.google.devtools.build.android.desugar.runtime.ThrowableExtension

# Proguard annotation warnings
-dontwarn proguard.annotation.Keep
-dontwarn proguard.annotation.KeepClassMembers

# Razorpay missing classes / keep rules
-dontwarn com.razorpay.**
-keep class com.razorpay.** { *; }
