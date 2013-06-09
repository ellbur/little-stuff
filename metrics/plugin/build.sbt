
name := "metrics"

unmanagedResourceDirectories in Compile <<= baseDirectory (base => Seq(
    base / "resources"
))

// I don't know how this line works
libraryDependencies <+= scalaVersion("org.scala-lang" % "scala-compiler" % _ % "provided")

