# Itds

A very simple SQL server CLI tools just to ease the developer working on Mac or Linux.

# Usage

Help
```
$itds --help
```

Command parameters:
```
$itds -h <hostname> -P <password> -u <username> -d <contained_database> [SQL]
```

Execute a command
```
$itds -h <hostname> -d <database> select 1
+---+

+---+
| 1 |
+---+
```

Interactive mode
```
$itds -h <hostname> -d <mydb>
mydb> select(1)
+---+

+---+
| 1 |
+---+
mydb> exit
$
```
