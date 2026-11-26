plugins {
    application
    jacoco
    alias(libs.plugins.spotless)
}

group = "dev.alexle"
version = "0.1.0-SNAPSHOT"
description = "{{PROJECT_DESCRIPTION}}"

// Java 25 (LTS): Gradle finds an installed JDK 25 and fails without one.
java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(25)
    }
}

repositories {
    mavenCentral()
}

dependencies {
    testImplementation(platform(libs.junit.bom))
    testImplementation(libs.junit.jupiter)
    testRuntimeOnly(libs.junit.platform.launcher)
}

application {
    mainClass = "dev.alexle.{{PACKAGE_NAME}}.App"
}

// Every warning fails the build, as lint does in the other languages.
tasks.withType<JavaCompile>().configureEach {
    options.compilerArgs.addAll(listOf("-Xlint:all", "-Werror"))
}

tasks.test {
    useJUnitPlatform()
    finalizedBy(tasks.jacocoTestReport)
}

// Formatting: google-java-format. `./gradlew spotlessApply` fixes it;
// `./gradlew check` fails on unformatted code.
spotless {
    java {
        googleJavaFormat()
    }
}

// Coverage: the report in build/reports/jacoco/, and `./gradlew check`
// fails below the minimum. Raise it as coverage rises, never lower it to
// pass.
jacoco {
    toolVersion = libs.versions.jacoco.get()
}

// The entry point only wires things together.
val coveredClasses = files(
    sourceSets.main.get().output.classesDirs.map { dir ->
        fileTree(dir) { exclude("**/App.class") }
    },
)

tasks.jacocoTestReport {
    classDirectories.setFrom(coveredClasses)
}

tasks.jacocoTestCoverageVerification {
    classDirectories.setFrom(coveredClasses)
    violationRules {
        rule {
            limit {
                counter = "LINE"
                value = "COVEREDRATIO"
                minimum = "0.80".toBigDecimal()
            }
        }
    }
}

tasks.check {
    dependsOn(tasks.jacocoTestCoverageVerification)
}
