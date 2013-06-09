
autoCompilerPlugins := true

addCompilerPlugin("org.scala-lang.plugins" % "continuations" % "2.9.1")

scalacOptions ++= Seq(
    "-P:continuations:enable",
    "-Xexperimental"
)

