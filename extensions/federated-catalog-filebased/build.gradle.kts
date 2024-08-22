plugins {
    `maven-publish`
    `java-library`
}

dependencies {
    implementation(edcLibs.edc.spi.core)
    implementation(edcLibs.edc.fc.spi.crawler)

    testImplementation(edcLibs.edc.junit)
}
