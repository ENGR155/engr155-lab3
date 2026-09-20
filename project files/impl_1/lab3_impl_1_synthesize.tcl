if {[catch {

# define run engine funtion
source [file join {C:/lscc/radiant/2026.1} scripts tcl flow run_engine.tcl]
# define global variables
global para
set para(gui_mode) "1"
set para(prj_dir) "C:/Users/skantimahanty/Documents/GitHub/engr155-lab3/project files"
if {![file exists {C:/Users/skantimahanty/Documents/GitHub/engr155-lab3/project files/impl_1}]} {
  file mkdir {C:/Users/skantimahanty/Documents/GitHub/engr155-lab3/project files/impl_1}
}
cd {C:/Users/skantimahanty/Documents/GitHub/engr155-lab3/project files/impl_1}
# synthesize IPs
# synthesize VMs
# propgate constraints
file delete -force -- lab3_impl_1_cpe.ldc
::radiant::runengine::run_engine_newmsg cpe -syn synpro -f "lab3_impl_1.cprj" -a "iCE40UP"  -o lab3_impl_1_cpe.ldc
# synthesize top design
file delete -force -- lab3_impl_1.vm lab3_impl_1.ldc
if {[file normalize "C:/Users/skantimahanty/Documents/GitHub/engr155-lab3/project files/impl_1/lab3_impl_1_synplify.tcl"] != [file normalize "./lab3_impl_1_synplify.tcl"]} {
  file copy -force "C:/Users/skantimahanty/Documents/GitHub/engr155-lab3/project files/impl_1/lab3_impl_1_synplify.tcl" "./lab3_impl_1_synplify.tcl"
}
if {[ catch {::radiant::runengine::run_engine synpwrap -prj "lab3_impl_1_synplify.tcl" -log "lab3_impl_1.srf"} result options ]} {
    file delete -force -- lab3_impl_1.vm lab3_impl_1.ldc
    return -options $options $result
}
::radiant::runengine::run_postsyn [list -a iCE40UP -p iCE40UP5K -t SG48 -sp High-Performance_1.2V -oc Industrial -top -w -o lab3_impl_1_syn.udb lab3_impl_1.vm] [list lab3_impl_1.ldc]

} out]} {
   ::radiant::runengine::runtime_log $out
   exit 1
}
