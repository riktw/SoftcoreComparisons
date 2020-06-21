val spinalVersion = "1.4.0"

lazy val root = (project in file("."))
  .settings(
    inThisBuild(List(
      organization := "com.github.spinalhdl",
      scalaVersion := "2.11.12",
      version      := "0.1.0-SNAPSHOT"
    )),
    name := "superproject",
    libraryDependencies ++= Seq(
      "com.github.spinalhdl" % "spinalhdl-core_2.11" % spinalVersion,
      "com.github.spinalhdl" % "spinalhdl-lib_2.11" % spinalVersion,
      compilerPlugin("com.github.spinalhdl" % "spinalhdl-idsl-plugin_2.11" % spinalVersion)
    )
  ).dependsOn(vexRiscv)

//For dependancies localy on your computer : 
lazy val vexRiscv = RootProject(file("./ext/VexRiscv"))

//For dependancies on a git : 
//lazy val vexRiscv = RootProject(uri("git://github.com/SpinalHDL/VexRiscv.git"))

//For dependancies on a git with a specific commit : 
//lazy val vexRiscv = RootProject(uri("git://github.com/SpinalHDL/VexRiscv.git#commitHash"))


fork := true
