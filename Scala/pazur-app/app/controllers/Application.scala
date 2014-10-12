package controllers

import play.api._
import play.api.libs.json.{JsPath, Writes}
import play.api.mvc._
import org.ddahl.jvmr.RInScala
import play.api.libs.json._
import play.api.libs.functional.syntax._

case class TTest(stat: Double, pvalue: Double)

object Application extends Controller {

  implicit val tTestWrites: Writes[TTest] = (
    (JsPath \ "stats").write[Double] and
      (JsPath \ "pvalue").write[Double]
    )(unlift(TTest.unapply))

  def index = Action {
    Ok(views.html.index("Your new application is ready."))
  }

  def tTest(vec1:List[Double],vec2:List[Double]) = Action{
    val R = RInScala()
    R.vec1=vec1.toArray
    R.vec2=vec2.toArray
    R.eval("test<-t.test(vec1,vec2)")
    val Pvalue = R.toPrimitive[Double]("test$p.value")
    val stats = R.toPrimitive[Double]("test$statistic")
    val tTest = new TTest(stats,Pvalue)
    val json = Json.toJson(tTest)
    Ok(json)
  }

}