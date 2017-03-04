
scalaVersion := "2.9.3"

scalaSource in Compile <<= baseDirectory

scalacOptions ++= Seq(
    "-Xexperimental",
    "-Xprint:typer"
)

resolvers += Resolver.sonatypeRepo("snapshots")

