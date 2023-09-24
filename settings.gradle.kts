rootProject.name = "e-connector-testbed"
include(":connector")
include(":extensions:testbed")

dependencyResolutionManagement {
    repositories {
        maven {
            url = uri("https://oss.sonatype.org/content/repositories/snapshots/")
        }
        mavenCentral()
        mavenLocal()
    }
}
