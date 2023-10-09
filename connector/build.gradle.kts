plugins {
    `java-library`
    application
    id("com.github.johnrengelman.shadow") version "8.1.1"
}

val edcGroup: String by project
val edcVersion: String by project
val txEdcGroup: String by project
val txEdcVersion: String by project
val sovityEdcGroup: String by project
val sovityEdcVersion: String by project

dependencies {
    implementation("${edcGroup}:control-plane-core:${edcVersion}")
    implementation("${edcGroup}:control-plane-aggregate-services:${edcVersion}")
    implementation("${edcGroup}:callback-event-dispatcher:${edcVersion}")
    implementation("${edcGroup}:callback-http-dispatcher:${edcVersion}")
    implementation("${edcGroup}:management-api:${edcVersion}")
    implementation("${edcGroup}:api-observability:${edcVersion}")
    implementation("${edcGroup}:auth-tokenbased:${edcVersion}")
    implementation("${edcGroup}:configuration-filesystem:${edcVersion}")
    implementation("${edcGroup}:vault-filesystem:${edcVersion}")

    implementation("${edcGroup}:dsp:${edcVersion}")
    implementation("${edcGroup}:oauth2-core:${edcVersion}")
    implementation("${edcGroup}:oauth2-daps:${edcVersion}")

    implementation("${edcGroup}:data-plane-core:${edcVersion}")
    //implementation("${edcGroup}:data-plane-api:${edcVersion}")
    implementation(project(":extensions:data-plane-api"))
    implementation("${edcGroup}:transfer-data-plane:${edcVersion}")
    implementation("${edcGroup}:transfer-pull-http-dynamic-receiver:${edcVersion}")
    implementation("${edcGroup}:data-plane-selector-core:${edcVersion}")
    implementation("${edcGroup}:data-plane-selector-api:${edcVersion}")
    implementation("${edcGroup}:data-plane-selector-client:${edcVersion}")
    implementation("${edcGroup}:data-plane-http:${edcVersion}")

    implementation("${txEdcGroup}:dataplane-selector-configuration:${txEdcVersion}")
    implementation("${txEdcGroup}:cx-oauth2:${txEdcVersion}")
    implementation("${txEdcGroup}:edr-core:${txEdcVersion}")
    implementation("${txEdcGroup}:edr-cache-core:${txEdcVersion}")
    implementation("${txEdcGroup}:edr-api:${txEdcVersion}")
    implementation("${txEdcGroup}:edr-callback:${txEdcVersion}")

    implementation("${sovityEdcGroup}:policy-referring-connector:${sovityEdcVersion}")
    implementation(project(":extensions:policies"))
}

application {
    mainClass.set("org.eclipse.edc.boot.system.runtime.BaseRuntime")
}

tasks.withType<com.github.jengelman.gradle.plugins.shadow.tasks.ShadowJar> {
    exclude("de/sovity/edc/extension/policy/ReferringConnectorValidationExtension.class")
    mergeServiceFiles()
    archiveFileName.set("connector.jar")
}
