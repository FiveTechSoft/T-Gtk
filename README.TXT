Quick guide to install t-gtk3 on GNU/Linux (Tested on Ubuntu 16.04 and 20.04)

After cloning the repository, switch to the gtk3 branch via:
git checkout gtk3

Then, run: 
```make```

When you run "make" for the first time, it will generate the configuration file which will have a name related to the platform you are working under. For example in Ubuntu 16.04 you can generate something like: *setenv_Ubuntu_16.04.7_x86_64.mk*

You can edit this file and make any adjustments you consider necessary such as possible path location for the Harbour compiler, location for the t-gtk library, additional components you want to incorporate in your builds, etc.  At the moment our goal is to get t-gtk working in GTK3 and GTK4 so it is not recommended for now to make further adjustments to the configuration file beyond the paths.

Once modified the setenv_XXXX, save the changes and now we are going to try to install the necessary dependencies to compile correctly our library; for this we will execute a script named "install.sh".

(Please run the script with root permissions)

After running "install.sh" and if everything was installed correctly, we can then proceed to run "make" again (with root permissions the first time, because we need to copy a file with library information for the pkg-config system).

The library compilation process will start. If everything went well, we will have inside the hbgtk and src/gclass folder the corresponding binaries (.a). And now we only have to execute "make install" so that the binaries are moved to the corresponding path, generally associated to the working platform and that is where the future compilations with t-gtk will look for those binaries. 



Spanish / Español

Guía rápida para instalar t-gtk3 en GNU/Linux (Probado en Ubuntu 16.04 y 20.04)

Después de clonar el repositorio, cambiar a la rama gtk3 mediante:
git checkout gtk3

Luego, ejecutar: 
```make```

Al ejecutar "make" por primera vez, se va a generar el fichero de configuración que tendrá un nombre relacionado con la plataforma bajo la cual está trabajando. Por ejemplo en Ubuntu 16.04 puede generar algo como: *setenv_Ubuntu_16.04.7_x86_64.mk*

De editar este fichero y realizar algún ajuste que considere necesario como posible ruta de ubicación del compilador Harbour, ubicación para la librería t-gtk, componentes adicionales que desee incorporar en sus compilaciones, etc.  De momento nuestro objetivo es obtener la t-gtk funcional en GTK3 y GTK4 por lo que no se recomienda por ahora hacer mayor ajuste al fichero de configuración más allá de las rutas.

Una vez modificado el setenv_XXXX, guarde los cambios y ahora vamos a intentar instalar las dependencias necesarias para compilar correctamente nuestra librería; para esto ejecutaremos un script de nombre "install.sh".

(Por favor ejecute el script con los permisos de root)

Tras ejecutar "install.sh" y si todo se instaló correctamente, podemos entonces proceder a ejecutar nuevamente "make" (con permisos de root la primera vez, porque se necesita copiar un fichero con información de la librería para el sistema pkg-config, )

Se iniciará el proceso de compilación de la librería. Si todo ha salido bien, tendremos dentro de la carpeta hbgtk y src/gclass los binarios (.a) correspondientes. Y ahora solo debemos ejecutar "make install" para que los binarios se trasladen a la ruta correspondiente, generalmente asociada a la plataforma de trabajo y que es donde las compilaciones futuras con t-gtk buscarán esos binarios. 
