plugins {
    `java-library`
    `maven-publish`
}

val testbedEdcGroup: String by project
val testbedEdcVersion: String by project
group = testbedEdcGroup
version = testbedEdcVersion

val edcGroup: String by project
val edcVersion: String by project

dependencies {
    api("${edcGroup}:http-spi:${edcVersion}")
    api("${edcGroup}:web-spi:${edcVersion}")
    api("${edcGroup}:data-plane-spi:${edcVersion}")
    implementation("${edcGroup}:data-plane-util:${edcVersion}")
    implementation("${edcGroup}:control-api-configuration:${edcVersion}")

    implementation(libs.jakarta.rsApi)
    implementation(libs.swagger.annotations.jakarta)

    testImplementation("${edcGroup}:http:${edcVersion}")
    testImplementation("${edcGroup}:junit:${edcVersion}")

    testImplementation(libs.jersey.multipart)
    testImplementation(libs.restAssured)
    testImplementation(libs.mockserver.netty)
    testImplementation(libs.mockserver.client)
}

publishing {
    publications {
        create<MavenPublication>(project.name) {
            from(components["java"])
        }
    }
}
