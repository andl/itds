# Itds [![CI] (https://travis-ci.org/andl/itds.svg?branch=master)] (https://travis-ci.org/andl/itds)

A deadly simple SQL server CLI tools just to ease the developer working on Mac or Linux.

# Dependency

Install freetds using the package manager of your system.
## Mac
```
$homebrew install freetds
```

## Ubuntu
```
$sudo apt-get install freetds-dev
```

# Install
```
$gem install itds
```

# Usage

Help
```
$itds --help
```

Command parameters:
```
$itds -h <hostname> -p <password> -u <username> -d <contained_database> [SQL]
```

Execute a command
```
$itds -h <hostname> -d <database> select 1
+---+

+---+
| 1 |
+---+
```

Cancel a request in interactive mode.
```
$itds -h <hostname> -d <mydb>
mydb> waitfor delay '00:00:04'
^C
mydb> select * from test
+----+
| id |
+----+
| 10 |
+----+
mydb> ^C
$
```
