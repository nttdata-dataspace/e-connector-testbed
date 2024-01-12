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
    api("${edcGroup}:data-plane-spi:${edcVersion}")
    implementation("${edcGroup}:util:${edcVersion}")
}

publishing {
    publications {
        create<MavenPublication>(project.name) {
            from(components["java"])
        }
    }
}
