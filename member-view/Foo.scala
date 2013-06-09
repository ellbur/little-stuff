
object Foo {
    trait Next {
        type A
        type N2 <: Next
        def next: A
        def nextNext(a: A): N2
        
        def next2: N2 = nextNext(next)
    }
    
    class NextInt(i: Int) extends Next {
        type A = Int
        type N2 = NextInt
        
        def next = i + 1
        def nextNext(a: Int) = new NextInt(a)
    }
    implicit def nextInt(i: Int) = new NextInt(i)

    def nextTwice(n: Next) = n.next2.next
    
    def main(args: Array[String]) {
        println(1.next)
        println(1.next.next)
        
        val a = 1
        val b = nextTwice(a)
        val c = nextTwice(b)
        println(a)
        println(b)
        println(c)
    }
}

