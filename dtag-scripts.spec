Summary: E5-MS customized scripts package
Name: dtag-scripts
Version: 1.0
Release: 0.0
Group: Applications/System
URL: http://www.oracle.com
License: proprietary

%description
E5-MS customized scripts package for DTAG

%install
if rpm -q dtag-scripts > /dev/null
then 
echo "Removing existing dtag-scripts package"
rpm -e dtag-scripts
fi
mkdir -p $RPM_BUILD_ROOT/opt/E5-MS/commandManager/scripts/root/default/lib/
install -m 755 -t $RPM_BUILD_ROOT/opt/E5-MS/commandManager/scripts/root/default/ bulk_time_setting.bsh cocoanut.bsh meas_archive.bsh \
 metrica_alarms.bsh metrica_file_filter_V2.bsh
cp -r lib/ $RPM_BUILD_ROOT/opt/E5-MS/commandManager/scripts/root/default/
chmod +x $RPM_BUILD_ROOT/opt/E5-MS/commandManager/scripts/root/default/lib/*
ln $RPM_BUILD_ROOT/opt/E5-MS/commandManager/scripts/root/default/lib/cocoanut_cmds.bsh $RPM_BUILD_ROOT/opt/E5-MS/commandManager/scripts/root/default/
ln $RPM_BUILD_ROOT/opt/E5-MS/commandManager/scripts/root/default/lib/include_metrica_files.bsh $RPM_BUILD_ROOT/opt/E5-MS/commandManager/scripts/root/default/

%post
echo "add or delete any dummy script via GUI to update the script list"

%clean
rm -f $RPM_BUILD_ROOT/opt/E5-MS/commandManager/scripts/root/default/bulk_time_setting.bsh
rm -f $RPM_BUILD_ROOT/opt/E5-MS/commandManager/scripts/root/default/cocoanut.bsh
rm -f $RPM_BUILD_ROOT/opt/E5-MS/commandManager/scripts/root/default/meas_archive.bsh
rm -f $RPM_BUILD_ROOT/opt/E5-MS/commandManager/scripts/root/default/metrica_alarms.bsh
rm -f $RPM_BUILD_ROOT/opt/E5-MS/commandManager/scripts/root/default/metrica_file_filter_V2.bsh
rm -f $RPM_BUILD_ROOT/opt/E5-MS/commandManager/scripts/root/default/lib/cocoanut_cmds.bsh
rm -f $RPM_BUILD_ROOT/opt/E5-MS/commandManager/scripts/root/default/lib/EagleIface.bsh
rm -f $RPM_BUILD_ROOT/opt/E5-MS/commandManager/scripts/root/default/lib/include_metrica_files.bsh
rm -f $RPM_BUILD_ROOT/opt/E5-MS/commandManager/scripts/root/default/lib/measurement.bash
rm -f $RPM_BUILD_ROOT/opt/E5-MS/commandManager/scripts/root/default/lib/tgznscp.bash
rm -f $RPM_BUILD_ROOT/opt/E5-MS/commandManager/scripts/root/default/lib/txt2csv.bsh

%files
/opt/E5-MS/commandManager/scripts/root/default/bulk_time_setting.bsh
/opt/E5-MS/commandManager/scripts/root/default/cocoanut.bsh
/opt/E5-MS/commandManager/scripts/root/default/meas_archive.bsh
/opt/E5-MS/commandManager/scripts/root/default/metrica_alarms.bsh
/opt/E5-MS/commandManager/scripts/root/default/metrica_file_filter_V2.bsh
/opt/E5-MS/commandManager/scripts/root/default/lib/cocoanut_cmds.bsh
/opt/E5-MS/commandManager/scripts/root/default/lib/EagleIface.bsh
/opt/E5-MS/commandManager/scripts/root/default/lib/include_metrica_files.bsh
/opt/E5-MS/commandManager/scripts/root/default/lib/measurement.bash
/opt/E5-MS/commandManager/scripts/root/default/lib/tgznscp.bash
/opt/E5-MS/commandManager/scripts/root/default/lib/txt2csv.bsh

/opt/E5-MS/commandManager/scripts/root/default/cocoanut_cmds.bsh
/opt/E5-MS/commandManager/scripts/root/default/include_metrica_files.bsh
