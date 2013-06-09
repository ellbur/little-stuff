
name := "smacro"

organization := "local.ellbur"

version := "0.1-SNAPSHOT"

scalaVersion := "2.9.1"

target <<= baseDirectory(_ / ".target")

scalaSource in Compile <<= baseDirectory

unmanagedResourceDirectories in Compile <<= baseDirectory (base => Seq(
    base / "resources"
))

scalacOptions ++= Seq(
    "-deprecation",
    "-unchecked"
)

// I don't know how this line works
libraryDependencies <+= scalaVersion("org.scala-lang" % "scala-compiler" % _ % "provided")

resolvers += "Scala Tools Snapshots" at "http://scala-tools.org/repo-snapshots/"

libraryDependencies ++= Seq(
    "org.scalaz" % "scalaz-core_2.9.1" % "6.0.3"
)

publishArtifact in (Compile, packageDoc) := false

publishArtifact in (Compile, packageSrc) := false

