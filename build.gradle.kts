plugins {
    `java-library`
}

allprojects {
    pluginManager.withPlugin("java-library") {
	java {
	    val javaVersion = 17
	    toolchain {
		languageVersion.set(JavaLanguageVersion.of(javaVersion))
	    }
	    tasks.withType(JavaCompile::class.java) {
		options.release.set(javaVersion)
	    }
	}
    }
}
