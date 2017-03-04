
// https://github.com/samizdatco/arbor/blob/f94539238865c7ff7179b2f4b00084ccae1ddc39/docs/sample-project/main.js

(function($){

  var Renderer = function() {
    var particleSystem

    var that = {
      init:function(system) {
        particleSystem = system
        particleSystem.screenSize(800, 600)
        particleSystem.screenPadding(10)
      },
      
      redraw:function() {
        particleSystem.eachNode(function(node, pt) {
            p = $("#"+node.name)
            p.css("left", pt.x+"px")
            p.css("top", pt.y+"px")
            p.html(node.name+" "+Math.round(pt.x)+" "+Math.round(pt.y)+" "+node.fixed)
        })
        
        particleSystem.eachEdge(function(edge, pt1, pt2) {
        })
        
        jsPlumb.repaintEverything()
      }
    }

    return that
  }

    $(document).ready(function() {
        var sys = arbor.ParticleSystem(1000, 600, 0.5)
        sys.parameters({gravity:true})
        sys.renderer = Renderer()

        a = sys.addNode('a')
        b = sys.addNode('b')
        c = sys.addNode('c')
        sys.addEdge('a','b')
        sys.addEdge('a','c')
        sys.addEdge('b','c')
      
        jsPlumb.Defaults.Container = $("#viewport")
        jsPlumb.connect({source:'a', target:'b',
            anchor:'TopCenter',
            paintStyle:{strokeStyle:'#999', lineWidth:2},
            endpointStyle:{radius:1}
        })
        jsPlumb.connect({source:'a', target:'c',
            anchor:'TopCenter',
            paintStyle:{strokeStyle:'#999', lineWidth:2},
            endpointStyle:{radius:1}
        })
        jsPlumb.connect({source:'b', target:'c',
            anchor:'TopCenter',
            paintStyle:{strokeStyle:'#999', lineWidth:2},
            endpointStyle:{radius:1}
        })
    })

})(this.jQuery)

