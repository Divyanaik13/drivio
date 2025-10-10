-keep class com.razorpay.** { *; }
-dontwarn com.razorpay.**

# fix: missing "proguard.annotation" at shrink time
-dontwarn proguard.annotation.**
-keep class proguard.annotation.** { *; }
