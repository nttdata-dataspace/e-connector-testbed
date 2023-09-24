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
val sovityEdcGroup: String by project
val sovityEdcVersion: String by project

dependencies {
    api("${edcGroup}:core-spi:${edcVersion}")
    api("${edcGroup}:policy-engine-spi:${edcVersion}")
    api("${edcGroup}:control-plane-spi:${edcVersion}")
    implementation("${edcGroup}:api-core:${edcVersion}")
    implementation("${sovityEdcGroup}:policy-referring-connector:${sovityEdcVersion}")
}

publishing {
    publications {
        create<MavenPublication>(project.name) {
            from(components["java"])
        }
    }
}
