package com.recipeapp

import android.app.Application
import io.sentry.android.core.SentryAndroid

class RecipesApplication : Application() {
    override fun onCreate() {
        super.onCreate()

        SentryAndroid.init(this) { options ->
            options.dsn = "https://bceb054e6c587513747129212b35594b@o4509995069472769.ingest.de.sentry.io/4510379715985488"
            options.tracesSampleRate = 1.0
        }
    }
}
