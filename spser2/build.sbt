
scalaVersion := "2.10.0-SNAPSHOT"

scalacOptions ++= Seq(
    "-deprecation",
    "-unchecked",
    "-Xexperimental",
    "-explaintypes",
    "-Xlog-implicits"
)

resolvers += "Scala Tools Snapshots" at "http://scala-tools.org/repo-snapshots/"

libraryDependencies ++= Seq(
    "org.scalaz" % "scalaz-core_2.9.1" % "6.0.3"
)

