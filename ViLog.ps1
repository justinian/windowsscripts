$datestamp = Get-Date -format yyyy.MM.dd
$logfile = "~/Dropbox/Work/Daily/${datestamp}.md"
gvim --servername vilog --remote-silent $logfile
