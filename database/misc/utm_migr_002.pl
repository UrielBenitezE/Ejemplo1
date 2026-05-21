use File::Copy;
use sctban;
use Cwd;
&sctban_determine_os;
&sctban_os_specific_env;
$banner_home = $ENV{"BANNER_HOME"};
$sct_start_dir = cwd();
$sct_forms_dir="${sct_start_dir}${sctban_dirsep}forms";
$sct_gif_dir="${sct_start_dir}${sctban_dirsep}gif";
$sct_java_dir="${sct_start_dir}${sctban_dirsep}java";
$sct_jar_dir="${sct_start_dir}${sctban_dirsep}java${sctban_dirsep}jar";
$sct_help_dir="${sct_start_dir}${sctban_dirsep}help";
$sct_help_helpsrc_dir="${sct_start_dir}${sctban_dirsep}help${sctban_dirsep}helpsrc";
$sct_desktop_edi_dir="${sct_start_dir}${sctban_dirsep}desktop${sctban_dirsep}edi";
$sct_htm_dir="${sct_start_dir}${sctban_dirsep}htm";
$sct_htm_images_dir="${sct_start_dir}${sctban_dirsep}htm${sctban_dirsep}images";
$sct_ico_dir="${sct_start_dir}${sctban_dirsep}ico";
$sct_misc_dir="${sct_start_dir}${sctban_dirsep}misc";
$sct_resources_dir="${sct_start_dir}${sctban_dirsep}resources";
#
$mods_home= "${banner_home}${sctban_dirsep}mcla${sctban_dirsep}mod002";

#
# AUDIT TRAIL: 9.3.32 [MCLA:002:2.0]             MHI  26/FEB/2025
#
# Migrate BANNER objects to permanent directories.
# AUDIT TRAIL END
#

#
# Create MODS directories
#
chdir("${banner_home}") || die "Cannot change to ${banner_home}:\n $!";

$directory = ".\\mcla";
unless(-e ${directory}){
   system("mkdir","${directory}");
   if ( $? == 1 ){print "Unable to create ${directory}\n $!";}
}

chdir("${directory}") || die "Cannot change to ${directory}:\n $!";

$directory = ".\\mod002";
unless(-e ${directory}){
   system("mkdir","${directory}");
   if ( $? == 1 ){print "Unable to create ${directory}\n $!";}
}

chdir("${directory}") || die "Cannot change to ${directory}:\n $!";

$directory = ".\\c";
unless(-e ${directory}){
   system("mkdir","${directory}");
   if ( $? == 1 ){print "Unable to create ${directory}\n $!";}
}

$directory = ".\\dbprocs";
unless(-e ${directory}){
   system("mkdir","${directory}");
   if ( $? == 1 ){print "Unable to create ${directory}\n $!";}
}

$directory = ".\\misc";
unless(-e ${directory}){
   system("mkdir","${directory}");
   if ( $? == 1 ){print "Unable to create ${directory}\n $!";}
}

$directory = ".\\plus";
unless(-e ${directory}){
   system("mkdir","${directory}");
   if ( $? == 1 ){print "Unable to create ${directory}\n $!";}
}

$directory = ".\\resources";
unless(-e ${directory}){
   system("mkdir","${directory}");
   if ( $? == 1 ){print "Unable to create ${directory}\n $!";}
}

#
# COPY STUDENT C
#
#
chdir("${sct_start_dir}") || die "Cannot change to ${sct_start_dir}:\n $!";
copy("szpcanp.pc", "${mods_home}${sctban_dirsep}c${sctban_dirsep}szpcanp.pc" ) || warn "Cannot migrate szpcanp.pc\n $!";

chdir("${sct_start_dir}") || die "Cannot change to ${sct_start_dir}:\n $!";
copy("szpcoav.pc", "${mods_home}${sctban_dirsep}c${sctban_dirsep}szpcoav.pc" ) || warn "Cannot migrate szpcoav.pc\n $!";

chdir("${sct_start_dir}") || die "Cannot change to ${sct_start_dir}:\n $!";
copy("szpeqiv.pc", "${mods_home}${sctban_dirsep}c${sctban_dirsep}szpeqiv.pc" ) || warn "Cannot migrate szpeqiv.pc\n $!";

chdir("${sct_start_dir}") || die "Cannot change to ${sct_start_dir}:\n $!";
copy("szpgchg.pc", "${mods_home}${sctban_dirsep}c${sctban_dirsep}szpgchg.pc" ) || warn "Cannot migrate szpgchg.pc\n $!";

chdir("${sct_start_dir}") || die "Cannot change to ${sct_start_dir}:\n $!";
copy("szproll.pc", "${mods_home}${sctban_dirsep}c${sctban_dirsep}szproll.pc" ) || warn "Cannot migrate szproll.pc\n $!";

chdir("${sct_start_dir}") || die "Cannot change to ${sct_start_dir}:\n $!";
copy("szptrns.pc", "${mods_home}${sctban_dirsep}c${sctban_dirsep}szptrns.pc" ) || warn "Cannot migrate szptrns.pc\n $!";

chdir("${sct_start_dir}") || die "Cannot change to ${sct_start_dir}:\n $!";
copy("szrroll.pc", "${mods_home}${sctban_dirsep}c${sctban_dirsep}szrroll.pc" ) || warn "Cannot migrate szrroll.pc\n $!";

chdir("${sct_start_dir}") || die "Cannot change to ${sct_start_dir}:\n $!";
copy("szpamec.pc", "${mods_home}${sctban_dirsep}c${sctban_dirsep}szpamec.pc" ) || warn "Cannot migrate szpamec.pc\n $!";

chdir("${sct_start_dir}") || die "Cannot change to ${sct_start_dir}:\n $!";
copy("szpcada.pc", "${mods_home}${sctban_dirsep}c${sctban_dirsep}szpcada.pc" ) || warn "Cannot migrate szpcada.pc\n $!";

chdir("${sct_start_dir}") || die "Cannot change to ${sct_start_dir}:\n $!";
copy("szpcasc.pc", "${mods_home}${sctban_dirsep}c${sctban_dirsep}szpcasc.pc" ) || warn "Cannot migrate szpcasc.pc\n $!";

chdir("${sct_start_dir}") || die "Cannot change to ${sct_start_dir}:\n $!";
copy("szpcasd.pc", "${mods_home}${sctban_dirsep}c${sctban_dirsep}szpcasd.pc" ) || warn "Cannot migrate szpcasd.pc\n $!";

chdir("${sct_start_dir}") || die "Cannot change to ${sct_start_dir}:\n $!";
copy("szpcmes.pc", "${mods_home}${sctban_dirsep}c${sctban_dirsep}szpcmes.pc" ) || warn "Cannot migrate szpcmes.pc\n $!";

chdir("${sct_start_dir}") || die "Cannot change to ${sct_start_dir}:\n $!";
copy("szpmrks.pc", "${mods_home}${sctban_dirsep}c${sctban_dirsep}szpmrks.pc" ) || warn "Cannot migrate szpmrks.pc\n $!";

#
# COPY DBPROCS
#
chdir("${sct_start_dir}") || die "Cannot change to ${sct_start_dir}:\n $!";

copy("szkuti1.sql",        "${mods_home}${sctban_dirsep}dbprocs${sctban_dirsep}szkuti1.sql" )        || warn "Cannot migrate szkuti1.sql\n       $!";
copy("szkutil.sql",       "${mods_home}${sctban_dirsep}dbprocs${sctban_dirsep}szkutil.sql" )       || warn "Cannot migrate szkutil.sql\n      $!";

copy("szkgchg.sql",        "${mods_home}${sctban_dirsep}dbprocs${sctban_dirsep}szkgchg.sql" )        || warn "Cannot migrate szkgchg.sql\n       $!";
copy("szkgch1.sql",       "${mods_home}${sctban_dirsep}dbprocs${sctban_dirsep}szkgch1.sql" )       || warn "Cannot migrate szkgch1.sql\n      $!";

copy("szkrols.sql",        "${mods_home}${sctban_dirsep}dbprocs${sctban_dirsep}szkrols.sql" )        || warn "Cannot migrate szkrols.sql\n       $!";
copy("szkrol1.sql",       "${mods_home}${sctban_dirsep}dbprocs${sctban_dirsep}szkrol1.sql" )       || warn "Cannot migrate szkrol1.sql\n      $!";

copy("szhkegr1.sql",        "${mods_home}${sctban_dirsep}dbprocs${sctban_dirsep}szhkegr1.sql" )        || warn "Cannot migrate szhkegr1.sql\n       $!";

copy("szpmrks.sql",        "${mods_home}${sctban_dirsep}dbprocs${sctban_dirsep}szpmrks.sql" )        || warn "Cannot migrate szpmrks.sql\n       $!";
copy("szpmrk1.sql",       "${mods_home}${sctban_dirsep}dbprocs${sctban_dirsep}szpmrk1.sql" )       || warn "Cannot migrate szpmrk1.sql\n      $!";

copy("gokutls.sql",        "${mods_home}${sctban_dirsep}dbprocs${sctban_dirsep}gokutls.sql" )        || warn "Cannot migrate gokutls.sql\n       $!";
copy("gokutl1.sql",       "${mods_home}${sctban_dirsep}dbprocs${sctban_dirsep}gokutl1.sql" )       || warn "Cannot migrate gokutl1.sql\n      $!";

copy("szksecg.sql",        "${mods_home}${sctban_dirsep}dbprocs${sctban_dirsep}szksecg.sql" )        || warn "Cannot migrate szksecg.sql\n       $!";
copy("szksec1.sql",       "${mods_home}${sctban_dirsep}dbprocs${sctban_dirsep}szksec1.sql" )       || warn "Cannot migrate szksec1.sql\n      $!";


#
# COPY PLUS
#
chdir("${sct_start_dir}") || die "Cannot change to ${sct_start_dir}:\n $!";
copy("gtvsdaxi_002.sql",        "${mods_home}${sctban_dirsep}plus${sctban_dirsep}gtvsdaxi_002.sql" )        || warn "Cannot migrate gtvsdaxi_002.sql\n $!";


#
# TABLES
#

copy("szbschm_090334_00.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szbschm_090334_00.sql" )            || warn "Cannot migrate szbschm_090334_00.sql\n $!";
copy("szbschm_090334_01.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szbschm_090334_01.sql" )            || warn "Cannot migrate szbschm_090334_01.sql\n $!";
copy("szbschm_090334_02.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szbschm_090334_02.sql" )            || warn "Cannot migrate szbschm_090334_02.sql\n $!";
copy("szbschm_090334_03.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szbschm_090334_03.sql" )            || warn "Cannot migrate szbschm_090334_03.sql\n $!";
copy("szbschm_090334_exists.sql",        "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szbschm_090334_exists.sql" )        || warn "Cannot migrate szbschm_090334_exists.sql\n $!";

copy("szraatr_090334_00.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szraatr_090334_00.sql" )            || warn "Cannot migrate szraatr_090334_00.sql\n $!";
copy("szraatr_090334_01.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szraatr_090334_01.sql" )            || warn "Cannot migrate szraatr_090334_01.sql\n $!";
copy("szraatr_090334_02.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szraatr_090334_02.sql" )            || warn "Cannot migrate szraatr_090334_02.sql\n $!";
copy("szraatr_090334_03.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szraatr_090334_03.sql" )            || warn "Cannot migrate szraatr_090334_03.sql\n $!";
copy("szraatr_090334_exists.sql",        "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szraatr_090334_exists.sql" )        || warn "Cannot migrate szraatr_090334_exists.sql\n $!";

copy("szratrk_090334_00.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szratrk_090334_00.sql" )            || warn "Cannot migrate szratrk_090334_00.sql\n $!";
copy("szratrk_090334_01.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szratrk_090334_01.sql" )            || warn "Cannot migrate szratrk_090334_01.sql\n $!";
copy("szratrk_090334_02.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szratrk_090334_02.sql" )            || warn "Cannot migrate szratrk_090334_02.sql\n $!";
copy("szratrk_090334_03.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szratrk_090334_03.sql" )            || warn "Cannot migrate szratrk_090334_03.sql\n $!";
copy("szratrk_090334_exists.sql",        "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szratrk_090334_exists.sql" )        || warn "Cannot migrate szratrk_090334_exists.sql\n $!";

copy("szrcrns_090334_00.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrcrns_090334_00.sql" )            || warn "Cannot migrate szrcrns_090334_00.sql\n $!";
copy("szrcrns_090334_01.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrcrns_090334_01.sql" )            || warn "Cannot migrate szrcrns_090334_01.sql\n $!";
copy("szrcrns_090334_02.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrcrns_090334_02.sql" )            || warn "Cannot migrate szrcrns_090334_02.sql\n $!";
copy("szrcrns_090334_03.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrcrns_090334_03.sql" )            || warn "Cannot migrate szrcrns_090334_03.sql\n $!";
copy("szrcrns_090334_exists.sql",        "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrcrns_090334_exists.sql" )        || warn "Cannot migrate szrcrns_090334_exists.sql\n $!";

copy("szrlfda_090334_00.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrlfda_090334_00.sql" )            || warn "Cannot migrate szrlfda_090334_00.sql\n $!";
copy("szrlfda_090334_01.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrlfda_090334_01.sql" )            || warn "Cannot migrate szrlfda_090334_01.sql\n $!";
copy("szrlfda_090334_02.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrlfda_090334_02.sql" )            || warn "Cannot migrate szrlfda_090334_02.sql\n $!";
copy("szrlfda_090334_03.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrlfda_090334_03.sql" )            || warn "Cannot migrate szrlfda_090334_03.sql\n $!";
copy("szrlfda_090334_exists.sql",        "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrlfda_090334_exists.sql" )        || warn "Cannot migrate szrlfda_090334_exists.sql\n $!";

copy("szrmrks_090334_00.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrmrks_090334_00.sql" )            || warn "Cannot migrate szrmrks_090334_00.sql\n $!";
copy("szrmrks_090334_01.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrmrks_090334_01.sql" )            || warn "Cannot migrate szrmrks_090334_01.sql\n $!";
copy("szrmrks_090334_02.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrmrks_090334_02.sql" )            || warn "Cannot migrate szrmrks_090334_02.sql\n $!";
copy("szrmrks_090334_03.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrmrks_090334_03.sql" )            || warn "Cannot migrate szrmrks_090334_03.sql\n $!";
copy("szrmrks_090334_exists.sql",        "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrmrks_090334_exists.sql" )        || warn "Cannot migrate szrmrks_090334_exists.sql\n $!";

copy("szrsatr_090334_00.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrsatr_090334_00.sql" )            || warn "Cannot migrate szrsatr_090334_00.sql\n $!";
copy("szrsatr_090334_01.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrsatr_090334_01.sql" )            || warn "Cannot migrate szrsatr_090334_01.sql\n $!";
copy("szrsatr_090334_02.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrsatr_090334_02.sql" )            || warn "Cannot migrate szrsatr_090334_02.sql\n $!";
copy("szrsatr_090334_03.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrsatr_090334_03.sql" )            || warn "Cannot migrate szrsatr_090334_03.sql\n $!";
copy("szrsatr_090334_exists.sql",        "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrsatr_090334_exists.sql" )        || warn "Cannot migrate szrsatr_090334_exists.sql\n $!";

copy("szrschm_090334_00.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrschm_090334_00.sql" )            || warn "Cannot migrate szrschm_090334_00.sql\n $!";
copy("szrschm_090334_01.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrschm_090334_01.sql" )            || warn "Cannot migrate szrschm_090334_01.sql\n $!";
copy("szrschm_090334_02.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrschm_090334_02.sql" )            || warn "Cannot migrate szrschm_090334_02.sql\n $!";
copy("szrschm_090334_03.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrschm_090334_03.sql" )            || warn "Cannot migrate szrschm_090334_03.sql\n $!";
copy("szrschm_090334_exists.sql",        "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrschm_090334_exists.sql" )        || warn "Cannot migrate szrschm_090334_exists.sql\n $!";

copy("szvabjr_090334_00.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szvabjr_090334_00.sql" )            || warn "Cannot migrate szvabjr_090334_00.sql\n $!";
copy("szvabjr_090334_01.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szvabjr_090334_01.sql" )            || warn "Cannot migrate szvabjr_090334_01.sql\n $!";
copy("szvabjr_090334_02.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szvabjr_090334_02.sql" )            || warn "Cannot migrate szvabjr_090334_02.sql\n $!";
copy("szvabjr_090334_03.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szvabjr_090334_03.sql" )            || warn "Cannot migrate szvabjr_090334_03.sql\n $!";
copy("szvabjr_090334_exists.sql",        "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szvabjr_090334_exists.sql" )        || warn "Cannot migrate szvabjr_090334_exists.sql\n $!";

copy("szvacat_090334_00.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szvacat_090334_00.sql" )            || warn "Cannot migrate szvacat_090334_00.sql\n $!";
copy("szvacat_090334_01.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szvacat_090334_01.sql" )            || warn "Cannot migrate szvacat_090334_01.sql\n $!";
copy("szvacat_090334_02.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szvacat_090334_02.sql" )            || warn "Cannot migrate szvacat_090334_02.sql\n $!";
copy("szvacat_090334_03.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szvacat_090334_03.sql" )            || warn "Cannot migrate szvacat_090334_03.sql\n $!";
copy("szvacat_090334_exists.sql",        "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szvacat_090334_exists.sql" )        || warn "Cannot migrate szvacat_090334_exists.sql\n $!";

copy("szrstcr_090334_00.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrstcr_090334_00.sql" )            || warn "Cannot migrate szrstcr_090334_00.sql\n $!";
copy("szrstcr_090334_01.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrstcr_090334_01.sql" )            || warn "Cannot migrate szrstcr_090334_01.sql\n $!";
copy("szrstcr_090334_02.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrstcr_090334_02.sql" )            || warn "Cannot migrate szrstcr_090334_02.sql\n $!";
copy("szrstcr_090334_03.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrstcr_090334_03.sql" )            || warn "Cannot migrate szrstcr_090334_03.sql\n $!";
copy("szrstcr_090334_exists.sql",        "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrstcr_090334_exists.sql" )        || warn "Cannot migrate szrstcr_090334_exists.sql\n $!";

copy("szrgchg_090334_00.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrgchg_090334_00.sql" )            || warn "Cannot migrate szrgchg_090334_00.sql\n $!";
copy("szrgchg_090334_01.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrgchg_090334_01.sql" )            || warn "Cannot migrate szrgchg_090334_01.sql\n $!";
copy("szrgchg_090334_02.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrgchg_090334_02.sql" )            || warn "Cannot migrate szrgchg_090334_02.sql\n $!";
copy("szrgchg_090334_03.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrgchg_090334_03.sql" )            || warn "Cannot migrate szrgchg_090334_03.sql\n $!";
copy("szrgchg_090334_exists.sql",        "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrgchg_090334_exists.sql" )        || warn "Cannot migrate szrgchg_090334_exists.sql\n $!";

copy("szreqiv_090334_00.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szreqiv_090334_00.sql" )            || warn "Cannot migrate szreqiv_090334_00.sql\n $!";
copy("szreqiv_090334_01.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szreqiv_090334_01.sql" )            || warn "Cannot migrate szreqiv_090334_01.sql\n $!";
copy("szreqiv_090334_02.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szreqiv_090334_02.sql" )            || warn "Cannot migrate szreqiv_090334_02.sql\n $!";
copy("szreqiv_090334_03.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szreqiv_090334_03.sql" )            || warn "Cannot migrate szreqiv_090334_03.sql\n $!";
copy("szreqiv_090334_exists.sql",        "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szreqiv_090334_exists.sql" )        || warn "Cannot migrate szreqiv_090334_exists.sql\n $!";

copy("sztlsch_083102_00.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}sztlsch_083102_00.sql" )            || warn "Cannot migrate sztlsch_083102_00.sql\n $!";
copy("sztlsch_083102_01.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}sztlsch_083102_01.sql" )            || warn "Cannot migrate sztlsch_083102_01.sql\n $!";
copy("sztlsch_083102_02.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}sztlsch_083102_02.sql" )            || warn "Cannot migrate sztlsch_083102_02.sql\n $!";
copy("sztlsch_083102_03.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}sztlsch_083102_03.sql" )            || warn "Cannot migrate sztlsch_083102_03.sql\n $!";
copy("sztlsch_083102_exists.sql",        "${mods_home}${sctban_dirsep}plus${sctban_dirsep}sztlsch_083102_exists.sql" )        || warn "Cannot migrate sztlsch_083102_exists.sql\n $!";

copy("sztvagr_083102_00.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}sztvagr_083102_00.sql" )            || warn "Cannot migrate sztvagr_083102_00.sql\n $!";
copy("sztvagr_083102_01.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}sztvagr_083102_01.sql" )            || warn "Cannot migrate sztvagr_083102_01.sql\n $!";
copy("sztvagr_083102_02.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}sztvagr_083102_02.sql" )            || warn "Cannot migrate sztvagr_083102_02.sql\n $!";
copy("sztvagr_083102_03.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}sztvagr_083102_03.sql" )            || warn "Cannot migrate sztvagr_083102_03.sql\n $!";
copy("sztvagr_083102_exists.sql",        "${mods_home}${sctban_dirsep}plus${sctban_dirsep}sztvagr_083102_exists.sql" )        || warn "Cannot migrate sztvagr_083102_exists.sql\n $!";

copy("sztveeq_083102_00.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}sztveeq_083102_00.sql" )            || warn "Cannot migrate sztveeq_083102_00.sql\n $!";
copy("sztveeq_083102_01.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}sztveeq_083102_01.sql" )            || warn "Cannot migrate sztveeq_083102_01.sql\n $!";
copy("sztveeq_083102_02.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}sztveeq_083102_02.sql" )            || warn "Cannot migrate sztveeq_083102_02.sql\n $!";
copy("sztveeq_083102_03.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}sztveeq_083102_03.sql" )            || warn "Cannot migrate sztveeq_083102_03.sql\n $!";
copy("sztveeq_083102_exists.sql",        "${mods_home}${sctban_dirsep}plus${sctban_dirsep}sztveeq_083102_exists.sql" )        || warn "Cannot migrate sztveeq_083102_exists.sql\n $!";

copy("sztvsch_083102_00.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}sztvsch_083102_00.sql" )            || warn "Cannot migrate sztvsch_083102_00.sql\n $!";
copy("sztvsch_083102_01.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}sztvsch_083102_01.sql" )            || warn "Cannot migrate sztvsch_083102_01.sql\n $!";
copy("sztvsch_083102_02.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}sztvsch_083102_02.sql" )            || warn "Cannot migrate sztvsch_083102_02.sql\n $!";
copy("sztvsch_083102_03.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}sztvsch_083102_03.sql" )            || warn "Cannot migrate sztvsch_083102_03.sql\n $!";
copy("sztvsch_083102_exists.sql",        "${mods_home}${sctban_dirsep}plus${sctban_dirsep}sztvsch_083102_exists.sql" )        || warn "Cannot migrate sztvsch_083102_exists.sql\n $!";

copy("szrabsc_083102_00.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrabsc_083102_00.sql" )            || warn "Cannot migrate szrabsc_083102_00.sql\n $!";
copy("szrabsc_083102_01.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrabsc_083102_01.sql" )            || warn "Cannot migrate szrabsc_083102_01.sql\n $!";
copy("szrabsc_083102_02.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrabsc_083102_02.sql" )            || warn "Cannot migrate szrabsc_083102_02.sql\n $!";
copy("szrabsc_083102_03.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrabsc_083102_03.sql" )            || warn "Cannot migrate szrabsc_083102_03.sql\n $!";
copy("szrabsc_083102_exists.sql",        "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrabsc_083102_exists.sql" )        || warn "Cannot migrate szrabsc_083102_exists.sql\n $!";

copy("shrgcom_090334_01.sql",            "${mods_home}${sctban_dirsep}plus${sctban_dirsep}shrgcom_090334_01.sql" )            || warn "Cannot migrate shrgcom_090334_01.sql\n $!";
copy("shrgcom_alter_script.sql",        "${mods_home}${sctban_dirsep}plus${sctban_dirsep}shrgcom_alter_script.sql" )        || warn "Cannot migrate shrgcom_alter_script.sql\n $!";


#
# TRIGGERS
#

copy("sz_crn_abscences_transfer.sql",    "${mods_home}${sctban_dirsep}plus${sctban_dirsep}sz_crn_abscences_transfer.sql" )    || warn "Cannot migrate sz_crn_abscences_transfer.sql\n $!";
copy("sz_fgrde_entry_upd.sql",           "${mods_home}${sctban_dirsep}plus${sctban_dirsep}sz_fgrde_entry_upd.sql" )    || warn "Cannot migrate sz_fgrde_entry_upd.sql\n $!";
copy("sztstcr_01.sql",                      "${mods_home}${sctban_dirsep}plus${sctban_dirsep}sztstcr_01.sql" )                      || warn "Cannot migrate sztstcr_01.sql\n $!";
copy("sztstcr.sql",                      "${mods_home}${sctban_dirsep}plus${sctban_dirsep}sztstcr.sql" )                      || warn "Cannot migrate sztstcr.sql\n $!";
copy("sotsatr.sql",                      "${mods_home}${sctban_dirsep}plus${sctban_dirsep}sotsatr.sql" )                      || warn "Cannot migrate sotsatr.sql\n $!";
copy("sotatrk.sql",                      "${mods_home}${sctban_dirsep}plus${sctban_dirsep}sotatrk.sql" )                      || warn "Cannot migrate sotatrk.sql\n $!";


#
# SQL OBJECTS
#

copy("szaandl_090334_objs.sql",                      "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szaandl_090334_objs.sql" )                      || warn "Cannot migrate szaandl_090334_objs.sql\n $!";
copy("szalfda_090334_objs.sql",                      "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szalfda_090334_objs.sql" )                      || warn "Cannot migrate szalfda_090334_objs.sql\n $!";
copy("szvabjr_090334_objs.sql",                      "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szvabjr_090334_objs.sql" )                      || warn "Cannot migrate szvabjr_090334_objs.sql\n $!";
copy("szaabjr_090334_objs.sql",                      "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szaabjr_090334_objs.sql" )                      || warn "Cannot migrate szaabjr_090334_objs.sql\n $!";
copy("szamrks_090334_objs.sql",                      "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szamrks_090334_objs.sql" )                      || warn "Cannot migrate szamrks_090334_objs.sql\n $!";
copy("szaabxt_090334_objs.sql",                      "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szaabxt_090334_objs.sql" )                      || warn "Cannot migrate szaabxt_090334_objs.sql\n $!";
copy("szaeqiv_090334_objs.sql",                      "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szaeqiv_090334_objs.sql" )                      || warn "Cannot migrate szaeqiv_090334_objs.sql\n $!";
copy("szaftop_090334_objs.sql",                      "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szaftop_090334_objs.sql" )                      || warn "Cannot migrate szaftop_090334_objs.sql\n $!";
copy("szagsma_090334_objs.sql",                      "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szagsma_090334_objs.sql" )                      || warn "Cannot migrate szagsma_090334_objs.sql\n $!";
copy("szaschc_090334_objs.sql",                      "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szaschc_090334_objs.sql" )                      || warn "Cannot migrate szaschc_090334_objs.sql\n $!";
copy("szvsaca_090334_objs.sql",                      "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szvsaca_090334_objs.sql" )                      || warn "Cannot migrate szvsaca_090334_objs.sql\n $!";
copy("szaschm_090334_objs.sql",                      "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szaschm_090334_objs.sql" )                      || warn "Cannot migrate szaschm_090334_objs.sql\n $!";

copy("szpcanp_083102_objs.sql",                      "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szpcanp_083102_objs.sql" )                      || warn "Cannot migrate szpcanp_083102_objs.sql\n $!";
copy("szpcoav_083102_objs.sql",                      "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szpcoav_083102_objs.sql" )                      || warn "Cannot migrate szpcoav_083102_objs.sql\n $!";
copy("szpeqiv_083102_objs.sql",                      "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szpeqiv_083102_objs.sql" )                      || warn "Cannot migrate szpeqiv_083102_objs.sql\n $!";
copy("szpgchg_083102_objs.sql",                      "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szpgchg_083102_objs.sql" )                      || warn "Cannot migrate szpgchg_083102_objs.sql\n $!";
copy("szproll_083102_objs.sql",                      "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szproll_083102_objs.sql" )                      || warn "Cannot migrate szproll_083102_objs.sql\n $!";
copy("szptrns_083102_objs.sql",                      "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szptrns_083102_objs.sql" )                      || warn "Cannot migrate szptrns_083102_objs.sql\n $!";
copy("szrroll_083102_objs.sql",                      "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szrroll_083102_objs.sql" )                      || warn "Cannot migrate szrroll_083102_objs.sql\n $!";
copy("szpamec_083102_objs.sql",                      "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szpamec_083102_objs.sql" )                      || warn "Cannot migrate szpamec_083102_objs.sql\n $!";
copy("szpcada_083102_objs.sql",                      "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szpcada_083102_objs.sql" )                      || warn "Cannot migrate szpcada_083102_objs.sql\n $!";
copy("szpcasc_083102_objs.sql",                      "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szpcasc_083102_objs.sql" )                      || warn "Cannot migrate szpcasc_083102_objs.sql\n $!";
copy("szpcasd_083102_objs.sql",                      "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szpcasd_083102_objs.sql" )                      || warn "Cannot migrate szpcasd_083102_objs.sql\n $!";
copy("szpcmes_083102_objs.sql",                      "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szpcmes_083102_objs.sql" )                      || warn "Cannot migrate szpcmes_083102_objs.sql\n $!";
copy("szpmrks_083102_objs.sql",                      "${mods_home}${sctban_dirsep}plus${sctban_dirsep}szpmrks_083102_objs.sql" )                      || warn "Cannot migrate szpmrks_083102_objs.sql\n $!";

copy("utm_install_mod002.sql",       "${mods_home}${sctban_dirsep}plus${sctban_dirsep}utm_install_mod002.sql" )       || warn "Cannot migrate utm_install_mod002.sql\n $!";


#
# COPY MISC
#
chdir("${sct_start_dir}") || die "Cannot change to ${sct_start_dir}:\n $!";
copy("utm_migr_002.pl",               "${mods_home}${sctban_dirsep}misc${sctban_dirsep}utm_migr_002.pl" )               || warn "Cannot migrate utm_migr_002.pl\n $!";
copy("utm_migr_002.shl",              "${mods_home}${sctban_dirsep}misc${sctban_dirsep}utm_migr_002.shl" )              || warn "Cannot migrate utm_migr_002.shl\n $!";
copy("utm_mod002_cmplc.shl",              "${mods_home}${sctban_dirsep}misc${sctban_dirsep}utm_mod002_cmplc.shl" )              || warn "Cannot migrate utm_mod002_cmplc.shl\n $!";
copy("UCUENCA_EC-002_STUENAH090334en.txt",       "${mods_home}${sctban_dirsep}misc${sctban_dirsep}UCUENCA_EC-002_STUENAH090334en.txt" )       || warn "Cannot migrate UCUENCA_EC-002_STUENAH090334en.txt\n $!";
