#######################################################
##                                                     #
##  Encounter Command File                             #
##                                                     #
##  Owner: austriamicrosystems                         #
##  HIT-Kit: Digital                                   #
##  version: 18-Jul-2012                               #
##                                                     #
########################################################

## Global variables
set topcellname "arm"
set dbdir "DB"
set consList {func test}

set HOME $env(HOME)
set AMS_DIR $env(AMS_DIR)
 
set checkedLogTilLine 0
 
if {[file exists "amsSetup.tcl"]} {
  source amsSetup.tcl
}

if {[file exists $HOME/.encounter_personal.tcl]} {
  source $HOME/.encounter_personal.tcl
  print "---# TCL Script $HOME/.encounter_personal.tcl loaded"
}


proc amc {start {end -1}} {
 if {$end == -1} { set end $start }
 for {set i $start} {$i<=$end} {incr i} {
   print "---# ---- Step $i -----"
   set step [format "s%d" $i]
   switch -exact $step {
   
      "s0"  { freeDesign }            
      "s1"  { amsDbSetup }            
      "s2"  { amsUserGrid }           
      "s3"  { amsGlobalConnect core } 
      "s4"  { amsSetMMMC }      
      "s5"  { amsSetAnalysisView minmax {func test} }      
      "s6"  { amsFloorplan core 0.8 50 }
      "s7"  { amsAddEndCaps }       
      "s9"  { amsPowerRoute  {{vdd! 20} {gnd! 20}} }
      "s10" { amsPlace ntd }       
      "s11" { amsCts }             
      "s12" { amsTa postCTS }
      "s13" { optDesign -postCTS }
      "s14" { amsFillperi }        
      "s15" { amsRoute wroute }   
      "s16" { amsFillcore }        
      "s17" { amsTa postRoute }
      "s18" { amsWrite final }
      "s19" { amsWriteSDF4View {func_min func_max} }
     } 
  }
  amsCheckLog
}

proc ha {} {
   info body amc
}
proc amsCheckLog {} {
   global checkedLogTilLine

   set logfilename [getLogFileName]
   system ams_checkEncLogs.pl -e -w -l $checkedLogTilLine $logfilename
   set chan [open $logfilename]
   set i 0
   while {[gets $chan line] >= 0} {
      set i [expr $i + 1]
   }
   set checkedLogTilLine $i
   close $chan
}

 addAMSHKMenu

##-- End of First Encounter TCL command file

