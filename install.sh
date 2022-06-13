#!/bin/bash

function setenv
{
  make
  nano $1
}

clear
echo "*------------------------------*"
echo "*                              *"
echo "* Install t-gtk on GNU/Linux   *"
echo "*                              *"
echo "*------------------------------*"
echo
if [ -z $1 ] ; then
   echo "debe indicar el archivo setenv a utilizar"
   echo "ejemplo: install setenv_Ubuntu_11.10.mk"
   exit
fi

test -f $1 || noexist=1

if [ $noexist = 1 ] ; then
   echo "no existe el archivo $1"
   exit
fi

install=''
global=./$1
tgtkPKG=/usr/lib/pkgconfig/tgtk3.pc

distro=`lsb_release -is`

test -f $global || $1

tgtk_pc=0
test -f $tgtkPKG && tgtk_pc=1
if [ $tgtk_pc = 0 ]; then
   echo "copiando $tgtkPKG" 
   cp ./utils/config_system/tgtk3_gnu.pc $tgtkPKG
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
dpkg --get-selections | grep "libgtk-3-dev" | grep dev && gtk=1 || gtk=0
if [ $gtk -eq 0 ] ; then
   apt-get install libgtk-3-dev
fi

#echo "detecting package glade for development"
#dpkg --get-selections | grep "libglade" | grep dev && glade=1 || glade=0
#if [ $glade -eq 0  ] ; then
#   apt-get install libglade2-dev
#fi

#--- GTK SourceView ---
scview=0
cmd=`cat $global | grep "export GTKSOURCEVIEW " | cut -d= -f2 `
if [ $cmd =  "yes" ] ; then
   echo "detecting package gtksourceview for development"
   dpkg --get-selections | grep "libgtksourceview-3.0-dev" && scview=1 || scview=0
   if [ $scview -eq 0 ] ; then
      install+='libgtksourceview3.0-dev '
      apt-get install libgtksourceview-3.0-dev
   fi
else
   echo "GTKSOURCEVIEW Set with value 'NO' in $global"
fi


#---  LIBGD ---
libgd=0
cmd=`cat $global | grep "export LIBGD" | cut -d= -f2`
if [ $cmd =  "yes" ] ; then
   echo "detecting package libgd for development"
   dpkg --get-selections | grep "libgd-dev" | grep dev && libgd=1 || libgd=0
   if [ $libgd -eq 0 ] ; then
      install+='libgd-dev '
#      apt-get install libgd-dev
   fi
else
   echo "LibGD Set with value 'NO' in $global"
fi


#---  CURL ---
curl=0
cmd=`cat $global | grep "export CURL" | cut -d= -f2`
if [ $cmd =  "yes" ] ; then
   echo "detecting package libcurl for development"
   dpkg --get-selections | grep "libcurl" | grep dev && curl=1 || curl=0
   if [ $curl -eq 0 ] ; then
      install+='libcurl4-openssl-dev '
#      apt-get install libcurl4-openssl-dev
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
   install+='libsqlite3-dev '
#      apt-get install libsqlite3-dev 
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
     if [ $distro = "Debian" ] ; then
        install+='libmariadbclient-dev-compat '
     else
        install+='libmysqlclient-dev '
     fi
#      apt-get install libmysqlclient-dev #mysql-gui-tools-common 
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
       install+='libpq-dev '
#      apt-get install libpq-dev
   fi
else
   echo "PostgreSQL Set with value 'NO' in $global"
fi


#--- Gnome Data Access ---
gda=0
cmd=`cat $global | grep "export GDA " | cut -d= -f2`
if [ $cmd =  "yes" ] ; then
   echo "detecting package libgda for development"
   dpkg --get-selections | grep "libgda-5.0-dev" && gda=1 || gda=0
   if [ $gda -eq 0 ] ; then
       install+='libgda-5.0-dev '
#      apt-get install libgda-5.0-dev
   fi
else
   echo "LibGDA Set with value 'NO' in $global"
fi


#--- WEBKIT ---
webkit=0
cmd=`cat $global | grep "export WEBKIT " | cut -d= -f2`
if [ $cmd =  "yes" ] ; then
   echo "detecting package libwebkit for development"
   dpkg --get-selections | grep "libweb2kit-4.0-dev" && webkit=1 || webkit=0
   if [ $webkit -eq 0 ] ; then
      if [ $distro = "Debian" ] ; then
        install+='libwebkitgtk-dev '
      else
        install+='libwebkit2gtk-4.0-dev '
      fi
#      apt-get install libwebkit-dev
   fi
else
   echo "WEBKIT Set with value 'NO' in $global"
fi


#--- VTE ---  Terminal Widget
vte=0
cmd=`cat $global | grep "export VTE " | cut -d= -f2`
if [ $cmd =  "yes" ] ; then
   echo "detecting package libvte for development"
   dpkg --get-selections | grep "libvte-dev" && vte=1 || vte=0
   if [ $vte -eq 0 ] ; then
       install+='libvte-dev '
      #apt-get install libvte-dev
   fi
else
   echo "VTE Set with value 'NO' in $global"
fi


#---  SSL ---
ssl=0
cmd=`cat $global | grep "export SSL" | cut -d= -f2`
if [ $cmd =  "yes" ] ; then
   echo "detecting package libssl for development"
   dpkg --get-selections | grep "libssl-dev" | grep dev && ssl=1 || ssl=0
   if [ $ssl -eq 0 ] ; then
      if [ $distro = "Debian" ] ; then
         install+='libssl1.0-dev ' # Esta generando error en Debian 9
      else
         install+='libssl-dev '
      fi
      install+='libkrb5-dev '
#      apt-get install libssl-dev
   fi
else
   echo "SSL Set with value 'NO' in $global"
fi

if [ -z $install ] ; then
   echo "nothing to install"
else
   apt-get install $install
fi
