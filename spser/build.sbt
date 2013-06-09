
target <<= baseDirectory(_ / ".target")

libraryDependencies ++= Seq(
    "net.liftweb" %% "lift-json" % "2.4-M4"
)

