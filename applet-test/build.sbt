
// https://github.com/adamw/xsbt-proguard-plugin

javaSource in Compile <<= baseDirectory(_ / "src")

seq(ProguardPlugin.proguardSettings :_*)

proguardOptions += keepMain("applettest.AppletMain")

