@file:JvmName("Service")

package com.priyoaujla.app

import org.http4k.core.Method
import org.http4k.core.Response
import org.http4k.core.Status
import org.http4k.routing.bind
import org.http4k.routing.routes
import org.http4k.server.Jetty
import org.http4k.server.asServer

fun main(args: Array<String>) {
    val app = routes(
            "/" bind Method.GET to { Response(Status.OK).body("The app is up and running!") }
    )

    app.asServer(Jetty(9000)).start()
}