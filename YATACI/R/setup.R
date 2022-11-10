initDataBase = function() {
    file = normalizePath(system.file("yataci.sql", package="YATACI"))
    cmd = paste("source", file)
    prc = processx::process$new( "mysql"
                                ,c("-u", "root", "-pjgg", "-e", cmd)
                                ,stdin = file
                                ,stdout = "|"
                                ,stderr = "2>&1")

    prc$wait()
    prc$get_exit_status()
}
