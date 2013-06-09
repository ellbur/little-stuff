
// For scalaz
resolvers += "Scala Tools Snapshots" at "http://scala-tools.org/repo-snapshots/"

libraryDependencies ++= Seq(
    "org.scalaz" % "scalaz-core_2.9.1" % "6.0.3",
    "org.xerial.thirdparty" % "sqlitejdbc-nested" % "3.6.2"
)

