
scalaVersion := "2.9.1"

target <<= baseDirectory(_ / ".target")

scalaSource in Compile <<= baseDirectory

javaSource in Compile <<= baseDirectory

scalacOptions ++= Seq(
    "-deprecation",
    "-unchecked",
    "-Xexperimental"
)

libraryDependencies ++= Seq(
    "org.prefuse" % "prefuse" % "beta-20071021"
)

