
package gaatest;

import java.io._
import javax.http.servlet._

class Main extends HttpServlet {
    def doGet(req: HttpServletRequest, resp: HttpServletResponse) {
        resp setContentType "text/plain"
        resp.getWriter println "Sup!"
    }
}

