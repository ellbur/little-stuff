
import dispatch._
import scalaz.Scalaz._
import akka.agent._
import akka.actor.Actor._

object Blaster {
    def main(args: Array[String]) {
        def targetURL = args(0)
            
        val shutdown = Agent[Boolean](false)
        val tallies = Agent[Tallies](Tallies())
        
        Runtime.getRuntime.addShutdownHook(new Thread () {
            override def run {
                tallies() |> report _
                shutdown send true
            }
        })
        
        spawn {
            while (!shutdown()) {
                Http(url(targetURL) >- { body =>
                    printf("Got %d chars\n", body.length)
                })
                tallies send (_.inc)
            }
        }
    }
    
    def report(t: Tallies) {
        val now = System currentTimeMillis
        
        printf("Count = %d\n", t.count)
        printf("Rate  = %.3f reqs/sec\n", t.count*1.0 / (now - t.start) * 1e3)
    }
    
    case class Tallies(
        count: Int  = 0,
        start: Long = System currentTimeMillis
    ) {
        def inc = copy(count=count+1)
    }
}

