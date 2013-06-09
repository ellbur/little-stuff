
traceLevel := 5

resolvers ++= Seq(
    "Akka repo"  at "http://akka.io/repository/",
    "Multiverse" at "http://multiverse.googlecode.com/svn/maven-repository/releases/",
    "GuicyFruit" at "http://guiceyfruit.googlecode.com/svn/repo/releases/",
    "JBoss"      at "https://repository.jboss.org/nexus/content/groups/public/"
)

libraryDependencies ++= Seq(
    "net.databinder" %% "dispatch-core" % "0.8.6",
    "net.databinder" %% "dispatch-http" % "0.8.6",
    "se.scalablesolutions.akka" % "akka" % "1.2",
    "org.scalaz" %% "scalaz-core" % "6.0.3",
    "org.apache.commons" % "commons-math" % "2.2"
)

