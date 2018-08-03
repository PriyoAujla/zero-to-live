@file:JvmName("Service")

package com.priyoaujla.app

import com.natpryce.konfig.EnvironmentVariables
import com.natpryce.konfig.Key
import com.natpryce.konfig.intType
import org.http4k.core.Method
import org.http4k.core.Response
import org.http4k.core.Status
import org.http4k.routing.bind
import org.http4k.routing.routes
import org.http4k.server.Jetty
import org.http4k.server.asServer

val config = EnvironmentVariables
object keys {
    object server {
        val port = Key("PORT", intType)
    }
}

fun main(args: Array<String>) {
    val app = routes(
            "/" bind Method.GET to { Response(Status.OK).body("Hello Tom!") }
    )

    app.asServer(Jetty(config[keys.server.port])).start()
}