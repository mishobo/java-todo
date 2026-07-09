# Java Task Manager Project

This is a simple **Java project** managed with **Gradle**. It uses **JUnit 5** for testing and comes with the **Gradle Wrapper (`gradlew`)** so you don’t need to install Gradle manually.

---

## What is `gradlew`?

The `gradlew` (Gradle Wrapper) script ensures that the project always uses a **specific version of Gradle**, regardless of what is installed on your system.

-  Consistency: Everyone uses the same Gradle version.  
-  Convenience: No need to install Gradle separately.  
-  Portability: Works on Linux, macOS, and Windows.  

Files related to the wrapper (and already in this repo):
- `gradlew` (Linux/macOS script)
- `gradlew.bat` (Windows script)
- `gradle/wrapper/gradle-wrapper.properties`
- `gradle/wrapper/gradle-wrapper.jar`

---

## Getting Started

### 1. Clone the repository
```bash
git clone <your-repo-url>
cd <project-folder>
```
### Build dependancies
```
./gradlew clean build 
```

### Run Tests
```
./gradlew test
```

### Run project
```
./gradlew run
```


1. CI-CD definition and principles - ELizabeth
2. setup tools jenkins, docker, conneting to GIT basic pipeline : Mwikali
3. advanced pipeline: vm deployment - Hussein