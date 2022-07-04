# Welcome to t-gtk!

The free implementation of GTK for Harbour (https://github.com/harbour/core).

## GNU/Linux (Ubuntu)
### Quick guide to install t-gtk3 on GNU/Linux (Tested on Ubuntu 16.04 and 20.04)

After cloning the repository, switch to the gtk3 branch via:
```git checkout gtk3```

Then, run: 
```make```

When you run "make" for the first time, it will generate the configuration file which will have a name related to the platform you are working under. For example in Ubuntu 16.04 you can generate something like: *setenv_Ubuntu_16.04.7_x86_64.mk*

You can edit this file and make any adjustments you consider necessary such as possible path location for the Harbour compiler, location for the t-gtk library, additional components you want to incorporate in your builds, etc.  At the moment our goal is to get t-gtk working in GTK3 and GTK4 so it is not recommended for now to make further adjustments to the configuration file beyond the paths.

Once modified the setenv_XXXX, save the changes and now we are going to try to install the necessary dependencies to compile correctly our library; for this we will execute a script named "install.sh".

(Please run the script with root permissions)

After running "install.sh" and if everything was installed correctly, we can then proceed to run "make" again (with root permissions the first time, because we need to copy a file with library information for the pkg-config system).

The library compilation process will start. If everything went well, we will have inside the hbgtk and src/gclass folder the corresponding binaries (.a). And now we only have to execute "make install" so that the binaries are moved to the corresponding path, generally associated to the working platform and that is where the future compilations with t-gtk will look for those binaries. 

## Windows
To compile t-gtk3 on Windows, it is necessary to have available Harbour compiled with mingw plus an additional set of dependencies and for this it is recommended to use [msys2]((https://www.msys2.org)).

### Download and install msys2 (https://github.com/msys2/msys2-installer/releases/download/2022-06-03/msys2-x86_64-20220603.exe)
After downloading and installing msys2, we must proceed to invoke a msys terminal window and update it using the instruction: 
`pacman -Syu`
After updating, we proceed to install the necessary dependencies (gtk3, pkg-config, glade):
`pacman -S --needed base-devel mingw-w64-x86_64-toolchain`

`pacman -S mingw-w64-x86_64-gcc mingw-w64-x86_64-pkg-config mingw-w64-x86_64-gtk3 mingw-w64-x86_64-glade`

If everything was OK, msys is installed in the "*c:\msys64*" folder and mingw is in the "*c:\msys64-mingw64*" folder.

Now that you have mingw, and everything we need so far, you can continue working in a standard windows terminal window. In this window, we will prepare the environment by setting some variables as follows:
`set PATH=c:\msys64\mingw;%PATH%`

We must also indicate the path to the Harbour binaries, if the location of your copy of harbour is: c:\harbour, then indicate:
`set PATH=c:\harbour\bin\win\mingw64;%PATH%`.

*Note: For convenience, it is recommended to copy c:\msys64\mingw64\bin\mingw32-make.exe to: c:\msys64\mingw64\bin\make.exe.

### Harbour construction
At this point, we position ourselves in the folder where we have hosted the copy of harbour and run `make`.

After several minutes and if everything has been executed well, you can invoke harbour by typing:
`harbour`

We should get harbour information, version and usage options; this means that it has been built well.

### Building t-gtk
Now that harbour and all the other necessary dependencies are available, we go to the folder where the copy of t-gtk is located and invoke `make`.

When executed for the first time, it will generate the file with variables necessary for a correct construction of t-gtk. This file adopts a name related to the working platform, e.g.: set_env_win_x86_64.mk

It is necessary to edit the generated file and place the correct values of paths to harbour, harbour version, gtk binaries, etc. Save the changes and rerun `make`.

Now the compilation of t-gtk will be performed taking into account the values in your set_env_xxx

After finishing the process correctly, you only need to run `make install` now to make the generated libraries available in the paths where they will be used later.

If everything is OK, you can check the contents in the lib folder inside t-gtk and see that you have a couple of files named libhbgtk.a and libgclass.a

You can then go to the test/[native | gclass] folder and then go to the subfolders with the examples and compile and run the final product.

We hope that all this will be of great use to you,


# Spanish / Español

### Guía rápida para instalar t-gtk3 en GNU/Linux (revisado en Ubuntu 16.04 y 20.04)

Después de clonar el repositorio, cambiar a la rama gtk3 mediante:
```git checkout gtk3```

Luego, ejecutar: 
```make```

Al ejecutar "make" por primera vez, se va a generar el fichero de configuración que tendrá un nombre relacionado con la plataforma bajo la cual está trabajando. Por ejemplo en Ubuntu 16.04 puede generar algo como: *setenv_Ubuntu_16.04.7_x86_64.mk*

De editar este fichero y realizar algún ajuste que considere necesario como posible ruta de ubicación del compilador Harbour, ubicación para la librería t-gtk, componentes adicionales que desee incorporar en sus compilaciones, etc.  De momento nuestro objetivo es obtener la t-gtk funcional en GTK3 y GTK4 por lo que no se recomienda por ahora hacer mayor ajuste al fichero de configuración más allá de las rutas.

Una vez modificado el setenv_XXXX, guarde los cambios y ahora vamos a intentar instalar las dependencias necesarias para compilar correctamente nuestra librería; para esto ejecutaremos un script de nombre "install.sh".

(Por favor ejecute el script con los permisos de root)

Tras ejecutar "install.sh" y si todo se instaló correctamente, podemos entonces proceder a ejecutar nuevamente "make" (con permisos de root la primera vez, porque se necesita copiar un fichero con información de la librería para el sistema pkg-config, )

Se iniciará el proceso de compilación de la librería. Si todo ha salido bien, tendremos dentro de la carpeta hbgtk y src/gclass los binarios (.a) correspondientes. Y ahora solo debemos ejecutar "make install" para que los binarios se trasladen a la ruta correspondiente, generalmente asociada a la plataforma de trabajo y que es donde las compilaciones futuras con t-gtk buscarán esos binarios. 

## Windows
Para compilar t-gtk3 en Windows, es necesario tener disponible Harbour  compilado con mingw más un conjunto adicional de dependencias y para esto se recomienda utilizar [msys2](https://www.msys2.org).

### Descarga e instalación de msys2 (https://github.com/msys2/msys2-installer/releases/download/2022-06-03/msys2-x86_64-20220603.exe)
Tras descargar e instalar msys2, debemos proceder a invocar una ventana de terminal de msys y actualizarlo mediante la instrucción: 
`pacman -Syu`
Luego de actualizar, procedemos a instalar las dependencias necesarias (gtk3, pkg-config, glade):
`pacman -S --needed base-devel mingw-w64-x86_64-toolchain`

`pacman -S mingw-w64-x86_64-gcc mingw-w64-x86_64-pkg-config mingw-w64-x86_64-gtk3 mingw-w64-x86_64-glade `

Si todo ha estado bien, msys se ha instalado en la carpeta "*c:\msys64*" y mingw está en la carpeta "*c:\msys64\mingw64*"

Ahora que ya se dispone de mingw, y todo lo que necesitamos hasta ahora; se puede continuar trabajando en una ventana de terminal estándar de windows. En esta ventana, vamos a preparar el entorno seteando algunas variables como se indica a continuación:
`set PATH=c:\msys64\mingw\bin;%PATH%`

También debemos indicar la ruta de los binarios de Harbour, si la ubicación de su copia de harbour es: c:\harbour, entonces indicar:
`set PATH=c:\harbour\bin\win\mingw64;%PATH%`

*Nota: Para mayor comodidad, es recomendable copiar c:\msys64\mingw64\bin\mingw32-make.exe a: c:\msys64\mingw64\bin\make.exe*

### Construcción de Harbour
En este momento, nos posicionamos en la carpeta donde tenemos alojada la copia de harbour y ejecutamos `make`

Tras varios minutos y si todo se ha ejecutado bien, puede invocar harbour escribiendo:
`harbour`

Debemos obtener información de harbour, versión y opciones de uso; esto significa que se ha construido bien.

### Construcción de t-gtk
Ahora que ya está harbour disponible y todas las demás dependencias necesarias, nos posicionamos en la carpeta donde está alojada la copia de t-gtk e invocamos `make`

Al ejecutar por primera vez, se va a generar el fichero con variables necesarias para una correcta construcción de t-gtk. Este fichero adopta un nombre relacionado con la plataforma de trabajo, ejemplo: set_env_win_x86_64.mk

Es necesario editar el archivo generado y colocar los valores correctos de rutas a harbour, version de harbour, binarios de gtk, etc. Guarde los cambios y vuelva a ejecutar `make`.

Ahora la compilación de t-gtk se realizará tomando en cuenta los valores en su set_env_xxx

Luego de finalizar el proceso en forma correcta, solo necesita ejecutar ahora `make install` para que las librerias generadas queden disponible en las rutas donde posteriormente serán utilizadas.

Si todo está bien, puede revisar el contenido en la carpeta lib dentro de t-gtk y ver que tiene un par de ficheros de nombre libhbgtk.a y libgclass.a

Puede entonces, posicionarse en la carpeta test/[native | gclass] e ir luego posicionarse en las subcarpeta con los ejemplos e ir compilando y ejecutando el producto final.

Esperamos que todo esto le sea de gran utilidad,


