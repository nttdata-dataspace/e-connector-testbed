rootProject.name = "e-connector-testbed"
include(":connector")
include(":extensions:vault-fs")
include(":extensions:oauth2-core")
include(":extensions:federated-catalog-filebased")

pluginManagement {
    repositories {
        mavenCentral()
        mavenLocal()
        gradlePluginPortal()
    }
}

dependencyResolutionManagement {
    versionCatalogs {
        create("edcLibs") {
            from(files("gradle/edc-libs.versions.toml"))
        }
    }
    repositories {
        maven {
            url = uri("https://oss.sonatype.org/content/repositories/snapshots/")
        }
        mavenCentral()
        mavenLocal()
    }
}
