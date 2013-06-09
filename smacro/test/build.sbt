
// traceLevel := 15

autoCompilerPlugins := true

addCompilerPlugin("local.ellbur" %% "smacro" % "0.1-SNAPSHOT")

resolvers += "Scala Tools Snapshots" at "http://scala-tools.org/repo-snapshots/"

libraryDependencies ++= Seq(
    "org.scalaz" % "scalaz-core_2.9.1" % "6.0.3"
)

classpathOptions ~= (_ copy (extra=true))

compilers <<= (managedClasspath in Compile, scalaInstance, appConfiguration,
        streams, classpathOptions, javaHome) map
{ (mc, si, app, s, co, jh) =>
    import compiler._
    s.log.info("Hi!!!")
    s.log.info("Managed classpath is " + mc)
    val extra = mc map (_.data) filter { file =>
        Seq("scalaz-core") exists (file.name contains _)
    }
    val newSi = new ScalaInstance(si.version, si.loader, si.libraryJar, si.compilerJar,
        si.extraJars++extra, si.explicitActual)
    s.log.info("Extra = " + newSi.extraJars)
    val compArgs = new CompilerArguments(newSi, co)
    s.log.info("Boot classpath = " + compArgs.createBootClasspath)
    s.log.info("Finish classpath = " + compArgs.finishClasspath(Nil))
    s.log.info("Classpath Options = " + co)
    s.log.info("Options = " + compArgs(Nil, Nil, file("/tmp"), Nil))
    Compiler.compilers(newSi, co, jh)(app, s.log)
}

