ECHO in the bat file
IF EXIST "../migrationassets" (
    ECHO found
) ELSE (
    ECHO not found
	DIR
)
mvn install -Denforcer.skip=true