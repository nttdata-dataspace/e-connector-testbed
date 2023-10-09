rootProject.name = "e-connector-testbed"
include(":connector")
include(":extensions:policies")
include(":extensions:data-plane-api")

dependencyResolutionManagement {
    repositories {
        maven {
            url = uri("https://oss.sonatype.org/content/repositories/snapshots/")
        }
        mavenCentral()
        mavenLocal()
    }
}
