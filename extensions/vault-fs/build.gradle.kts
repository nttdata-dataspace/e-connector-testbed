plugins {
    `java-library`
    `maven-publish`
}

dependencies {
    implementation(edcLibs.edc.spi.core)
    implementation(edcLibs.edc.spi.keys)
    implementation(edcLibs.edc.lib.keys)
    implementation(libs.bouncyCastle.bcpkixJdk18on)

    testImplementation(libs.nimbus.jwt)
    testImplementation(libs.bouncyCastle.bcprovJdk18on)
    testImplementation(edcLibs.edc.core.connector)
    testImplementation(libs.junit.jupiter.api)
    testImplementation(libs.assertj)
    testImplementation(libs.mockito.core)
}

publishing {
    publications {
        create<MavenPublication>(project.name) {
            from(components["java"])
        }
    }
}
