
mainClass := Some("Foo")

seq(ProguardPlugin.proguardSettings: _*)

proguardOptions += keepMain("Main")
