package utils.silhouette

import com.mohiva.play.silhouette.api.Authorization
import com.mohiva.play.silhouette.impl.authenticators.{ BearerTokenAuthenticator, CookieAuthenticator }
import play.api.mvc.Request
import scala.concurrent.Future
import models.User
import play.api.Logger

/**
 * Only allows those users that have at least a service of the selected.
 * Master service is always allowed.
 * Ex: WithService("serviceA", "serviceB") => only users with services "serviceA" OR "serviceB" (or "master") are allowed.
 */

case class WithCookieService(anyOf: String*) extends Authorization[User, CookieAuthenticator] {
  def isAuthorized[A](user: User, authenticator: CookieAuthenticator)(implicit r: Request[A]) = Future.successful {
    Logger.debug(user.loginInfo.toString)
    WithService.isAuthorized(user, anyOf: _*)
  }
}
case class WithService(anyOf: String*) extends Authorization[User, BearerTokenAuthenticator] {
  def isAuthorized[A](user: User, authenticator: BearerTokenAuthenticator)(implicit r: Request[A]) = Future.successful {
    Logger.debug(user.loginInfo.toString)
    WithService.isAuthorized(user, anyOf: _*)
  }
}
object WithService {
  def isAuthorized(user: User, anyOf: String*): Boolean = {
    Logger.debug(user.loginInfo.toString)
    anyOf.intersect(user.services).size > 0 || user.services.contains("master")
  }
}

/**
 * Only allows those users that have every of the selected services.
 * Master service is always allowed.
 * Ex: Restrict("serviceA", "serviceB") => only users with services "serviceA" AND "serviceB" (or "master") are allowed.
 */
case class WithServices(allOf: String*) extends Authorization[User, BearerTokenAuthenticator] {
  def isAuthorized[A](user: User, authenticator: BearerTokenAuthenticator)(implicit r: Request[A]) = Future.successful {
    WithServices.isAuthorized(user, allOf: _*)
  }
}
object WithServices {
  def isAuthorized(user: User, allOf: String*): Boolean =
    allOf.intersect(user.services).size == allOf.size || user.services.contains("master")
}