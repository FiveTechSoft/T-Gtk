#!/bin/bash

function setenv
{
  make
  nano setenv.mk
}

clear
echo "*------------------------------*"
echo "*                              *"
echo "* Install t-gtk on GNU/Linux   *"
echo "*                              *"
echo "*------------------------------*"
echo
global=./setenv.mk
tgtkPKG=/usr/lib/pkgconfig/tgtk.pc

test -f $global || setenv

tgtk_pc=0
test -f $tgtkPKG && tgtk_pc=1
if [ $tgtk_pc = 0 ]; then
   echo "copiando $tgtkPKG" 
   cp ./utils/config_system/tgtk_gnu.pc $tgtkPKG
   if test -f $tgtkPKG 
   then 
      echo "copiado." 
   else
      echo "No se ha podido realizar la copia del archivo de configuracion" 
      echo "Posiblemente el usuario $USER no posee permisos suficientes."
      exit
   fi
fi


echo "detecting package gtk for development"
dpkg --get-selections | grep "libgtk" | grep dev && gtk=1 || gtk=0
if [ $gtk -eq 0 ] ; then
   apt-get install libgtk2.0-dev
fi

echo "detecting package glade for development"
dpkg --get-selections | grep "libglade" | grep dev && glade=1 || glade=0
if [ $glade -eq 0  ] ; then
   apt-get install libglade2-dev
fi

#--- GTK SourceView ---
scview=0
cmd=`cat $global | grep "export GTKSOURCEVIEW " | cut -d= -f2 `
if [ $cmd =  "yes" ] ; then
   echo "detecting package gtksourceview for development"
   dpkg --get-selections | grep "libgtksourceview2.0-dev" && scview=1 || scview=0
   if [ $scview -eq 0 ] ; then
      apt-get install libgtksourceview2.0-dev
   fi
else
   echo "GTKSOURCEVIEW Set with value 'NO' in $global"
fi


#---  CURL ---
curl=0
cmd=`cat $global | grep "export CURL" | cut -d= -f2`
if [ $cmd =  "yes" ] ; then
   echo "detecting package libcurl for development"
   dpkg --get-selections | grep "libcurl" | grep dev && curl=1 || curl=0
   if [ $curl -eq 0 ] ; then
      apt-get install libcurl4-openssl-dev
   fi
else
   echo "CURL Set with value 'NO' in $global"
fi


#--- SQLite ---
sqlite=0
cmd=`cat $global | grep "export SQLITE" | cut -d= -f2`
if [ $cmd =  "yes" ] ; then
   echo "detecting package libsqlite3 for development"
   dpkg --get-selections | grep "libsqlite3-dev" | grep dev && sqlite=1 || sqlite=0
   if [ $sqlite -eq 0 ] ; then
      apt-get install libsqlite3-dev 
   fi
else
   echo "SQLite Set with value 'NO' in $global"
fi

#--- MySQL ---
mysql=0
cmd=`cat $global | grep "export MYSQL " | cut -d= -f2`
if [ $cmd =  "yes" ] ; then
   echo "detecting package libmysqlclient for development"
   dpkg --get-selections | grep "libmysqlclient" | grep dev && mysql=1 || mysql=0
   if [ $mysql -eq 0 ] ; then
      apt-get install libmysqlclient-dev mysql-gui-tools-common 
   fi
else
   echo "MySQL Set with value 'NO' in $global"
fi

#--- PostgreSQL ---
pgsql=0
cmd=`cat $global | grep "export POSTGRE " | cut -d= -f2`
if [ $cmd =  "yes" ] ; then
   echo "detecting package libpq for development"
   dpkg --get-selections | grep "libpq-dev" | grep dev && pgsql=1 || pgsql=0
   if [ $pgsql -eq 0 ] ; then
      apt-get install libpq-dev
   fi
else
   echo "PostgreSQL Set with value 'NO' in $global"
fi


#--- Gnome Data Access ---
gda=0
cmd=`cat $global | grep "export GNOMEDB " | cut -d= -f2`
if [ $cmd =  "yes" ] ; then
   echo "detecting package libgda for development"
   dpkg --get-selections | grep "libgda-4.0-dev" && gda=1 || gda=0
   if [ $gda -eq 0 ] ; then
      apt-get install libgda-4.0-dev
   fi
else
   echo "gnomedb Set with value 'NO' in $global"
fi


#--- WEBKIT ---
webkit=0
cmd=`cat $global | grep "export WEBKIT " | cut -d= -f2`
if [ $cmd =  "yes" ] ; then
   echo "detecting package libwebkit for development"
   dpkg --get-selections | grep "libwebkit-dev" && webkit=1 || webkit=0
   if [ $webkit -eq 0 ] ; then
      apt-get install libwebkit-dev
   fi
else
   echo "WEBKIT Set with value 'NO' in $global"
fi


