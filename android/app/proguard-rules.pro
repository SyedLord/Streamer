# Please add these rules to your existing keep rules in order to suppress warnings.
# This is generated automatically by the Android Gradle plugin.
-dontwarn com.google.errorprone.annotations.CanIgnoreReturnValue
-dontwarn com.google.errorprone.annotations.CheckReturnValue
-dontwarn com.google.errorprone.annotations.Immutable
-dontwarn com.google.errorprone.annotations.RestrictedApi
-dontwarn javax.annotation.Nullable
-dontwarn javax.annotation.concurrent.GuardedBy
-dontwarn org.bouncycastle.jce.provider.BouncyCastleProvider
-dontwarn org.bouncycastle.pqc.jcajce.provider.BouncyCastlePQCProvider
-dontwarn com.fasterxml.jackson.core.**
-dontwarn com.fasterxml.jackson.databind.**
-dontwarn com.google.auto.value.**
-keep class org.xmlpull.v1.** { *; }

# ─── Flutter ───────────────────────────────────────────────────────────────
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.**

# ─── Tera App ──────────────────────────────────────────────────────────────
-keep class com.syedlord.streamer.** { *; }
-keepclassmembers class com.syedlord.streamer.** { *; }

# ─── FFmpeg ────────────────────────────────────────────────────────────────
-keep class com.arthenica.ffmpegkit.** { *; }
-keep class com.arthenica.** { *; }
-dontwarn com.arthenica.**

# ─── flutter_background ────────────────────────────────────────────────────
-keep class de.julianassmann.flutter_background.** { *; }
-dontwarn de.julianassmann.**

# ─── flutter_local_notifications ───────────────────────────────────────────
-keep class com.dexterous.flutterlocalnotifications.** { *; }
-dontwarn com.dexterous.**

# ─── Google Sign In / Auth ─────────────────────────────────────────────────
-keep class com.google.android.gms.** { *; }
-keep class com.google.android.gms.auth.** { *; }
-keep class com.google.android.gms.common.** { *; }
-dontwarn com.google.android.gms.**

# ─── AdMob / Google Ads ────────────────────────────────────────────────────
-keep class com.google.android.gms.ads.** { *; }
-keep public class com.google.android.gms.ads.** {
   public *;
}

# ─── Google API (YouTube) ──────────────────────────────────────────────────
-keep class com.google.api.** { *; }
-dontwarn com.google.api.**

# ─── HTTP / OkHttp (YouTube API calls) ────────────────────────────────────
-keep class okhttp3.** { *; }
-keep class okio.** { *; }
-dontwarn okhttp3.**
-dontwarn okio.**

# ─── sqflite ───────────────────────────────────────────────────────────────
-keep class com.tekartik.sqflite.** { *; }
-dontwarn com.tekartik.sqflite.**

# ─── file_picker ───────────────────────────────────────────────────────────
-keep class com.mr.flutter.plugin.filepicker.** { *; }
-dontwarn com.mr.flutter.plugin.filepicker.**

# ─── image_picker ──────────────────────────────────────────────────────────
-keep class io.flutter.plugins.imagepicker.** { *; }
-dontwarn io.flutter.plugins.imagepicker.**

# ─── video_player ──────────────────────────────────────────────────────────
-keep class io.flutter.plugins.videoplayer.** { *; }
-dontwarn io.flutter.plugins.videoplayer.**

# ─── permission_handler ────────────────────────────────────────────────────
-keep class com.baseflow.permissionhandler.** { *; }
-dontwarn com.baseflow.permissionhandler.**

# ─── Kotlin ────────────────────────────────────────────────────────────────
-keep class kotlin.** { *; }
-keep class kotlin.Metadata { *; }
-dontwarn kotlin.**
-keepclassmembers class **$WhenMappings {
    <fields>;
}

# ─── Android Core ──────────────────────────────────────────────────────────
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keepattributes Signature
-keepattributes Exceptions
-keep class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator *;
}
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# ─── Method Channels ──────────────────────────────────────────────────────
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}