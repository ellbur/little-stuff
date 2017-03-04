
import sbt._

object MyApp extends Build {
    lazy val root =
        Project("", file(".")) dependsOn(squeryl)
    
    lazy val squeryl = file("/home/owen/install/Squeryl")
}

