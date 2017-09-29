void crear_archivo(File file){
    //var file_stream = file.create(FileCreateFlags.NONE);
    try{
        file.create(FileCreateFlags.NONE);
        if (file.query_exists ()){
            stdout.printf("Archivo creado");
        }

    }catch(Error e){
        error("%s",e.message);
    }
}

void main(){
    var path = "serverconfig.cfg";
    var file = File.new_for_path (path);
    if(!file.query_exists ()){
        stderr.printf ("Archivo '%s' no existe.\n", file.get_path ());
        print("Creando archivo %s".printf(file.get_path ()));
        crear_archivo(file);
    }
/*
   
*/
}

