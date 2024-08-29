plugins {
    `java-library`
    application
    alias(libs.plugins.shadow)
    alias(libs.plugins.swagger)
}

val txEdcGroup: String by project
val txEdcVersion: String by project
val sovityEdcGroup: String by project
val sovityEdcVersion: String by project

dependencies {
    implementation(project(":extensions:vault-fs"))
    implementation(project(":extensions:oauth2-core"))
    implementation(project(":extensions:federated-catalog-filebased"))
    implementation(project(":extensions:swagger-ui"))
    implementation("${sovityEdcGroup}:policy-referring-connector:${sovityEdcVersion}")

    implementation(edcLibs.edc.core.connector)
    implementation(edcLibs.edc.core.controlplane)
    implementation(edcLibs.edc.config.filesystem)
    implementation(edcLibs.edc.auth.tokenbased)
    implementation(edcLibs.edc.validator.data.address.http.data)
    implementation(edcLibs.edc.data.plane.selector.control.api)

    implementation(edcLibs.edc.api.management)
    implementation(edcLibs.edc.api.controlplane)
    implementation(edcLibs.edc.api.control.config)
    implementation(edcLibs.edc.api.observability)

    implementation(edcLibs.edc.dsp)
    implementation(edcLibs.edc.dpf.transfer.signaling)
    implementation(edcLibs.edc.dpf.selector.core)

    implementation(edcLibs.edc.ext.http)
    implementation(edcLibs.edc.transfer.dynamicreceiver)
    implementation(edcLibs.edc.controlplane.callback.dispatcher.event)
    implementation(edcLibs.edc.controlplane.callback.dispatcher.http)
    implementation(edcLibs.bundles.edc.monitoring)

    implementation(edcLibs.edc.dpf.core)
    implementation(edcLibs.edc.controlplane.apiclient)
    implementation(edcLibs.edc.data.plane.self.registration)
    implementation(edcLibs.edc.dpf.api.control)
    implementation(edcLibs.edc.dpf.api.signaling)
    implementation(edcLibs.edc.dpf.http)
    implementation(edcLibs.edc.dpf.api.public.v2)

    implementation(edcLibs.edc.core.edrstore)

    implementation(edcLibs.edc.fc.core)
    implementation(edcLibs.edc.fc.api)

    implementation(libs.postgres)
    implementation(edcLibs.edc.transaction.local)
    implementation(edcLibs.edc.sql.pool)
    implementation(edcLibs.edc.sql.assetindex)
    implementation(edcLibs.edc.sql.policydef)
    implementation(edcLibs.edc.sql.contract.definition)
    implementation(edcLibs.edc.sql.contract.negotiation)
    implementation(edcLibs.edc.sql.transferprocess)
    implementation(edcLibs.edc.sql.edrindex)
    implementation(edcLibs.edc.sql.accesstokendata)
    implementation(edcLibs.edc.sql.dataplane)
}

application {
    mainClass.set("org.eclipse.edc.boot.system.runtime.BaseRuntime")
}

var distZip = tasks.getByName("distZip")
var distTar = tasks.getByName("distTar")

tasks.withType<com.github.jengelman.gradle.plugins.shadow.tasks.ShadowJar> {
    mergeServiceFiles()
    archiveFileName.set("connector.jar")
    dependsOn(distZip, distTar)
}
