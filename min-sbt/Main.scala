
object Main {
    
    def main(args: Array[String]) {
        import graph._
        val nodes = Graph(
            0 -> N(
                1 x 1,
                2 x 3
            ),
            1 -> N(
                0 x 1,
                2 x 1
            ),
            2 -> N(
                0 x 3,
                1 x 1,
                3 x 1
            ),
            3 -> N(
                1 x 3,
                2 x 1
            )
        )
        
        import dijk.{findShortest}
        println({
            for {
                short <- findShortest(nodes, nodes(3), nodes(0))
                text = short map (_.index) mkString " "
            }
                yield text
        })
    }
}

