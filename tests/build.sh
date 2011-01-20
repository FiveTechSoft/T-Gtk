# ./build.sh


TGTK_PATH=$HOME/repos/tgtk/trunk

echo compiling...

harbour $1 -n -I$TGTK_PATH/include -I/usr/local/include/harbour

if [ $? -eq 0 ]; then
   echo compiling C module...
   gcc $1.c -c -I$TGTK_PATH/include -I/usr/local/include/harbour `pkg-config --cflags gtk+-2.0`

   if [ $? -eq 0 ]; then
      echo linking...
      gcc $1.o -o$1 -L$TGTK_PATH/lib -L/usr/local/lib/harbour `pkg-config --libs gtk+-2.0` `pkg-config --libs libglade-2.0` `pkg-config --libs libgnomeprintui-2.2` -Wl,--start-group -lgclass -lhbgtk -lhbcommon -lhbvm -lhbrtl -lhbrdd -lhbmacro -lhblang -lhbcpage -lhbpp -lrddntx -lrddcdx -lrddfpt -lhbsix -lhbusrrdd -lhbct -lgttrm -lhbdebug -lxhb -Wl,--end-group
      if [ $? -eq 1 ]; then
         read -p "error linking" x
      else
         rm $1.c
         rm $1.o
         echo done!
          $1
      fi
   else
      read -p "error compiling C module" x
   fi
else
   read -p "error compiling PRG module" x
fi

if [ $? -eq 1 ] then;
   read -p "runtime error" x
fi

