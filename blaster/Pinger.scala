
import dispatch._
import scalaz.Scalaz._
import akka.agent._
import akka.actor.Actor._

import org.apache.commons.math.stat.StatUtils._

object Pinger {
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
                val start = System currentTimeMillis ()
                Http(url(targetURL) >- { body =>
                    ()
                })
                val stop = System currentTimeMillis ()
                val time = (stop - start) * 1e-3
                
                printf("Took %.3f\n", time)
                tallies send (_ add time)
                
                Thread sleep 3000
            }
        }
    }
    
    def report(t: Tallies) {
        val arr = t.stats toArray
        
        printf("Q1  = %.2f s\n", percentile(arr, 25))
        printf("Med = %.2f s\n", percentile(arr, 50))
        printf("Q3  = %.2f s\n", percentile(arr, 75))
    }
    
    case class Tallies(
        stats: List[Double] = Nil
    ) {
        def add(d: Double) = copy(stats = d :: stats)
    }
}


