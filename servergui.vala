/*
Creado por: Juan Velandia - https://juankz.github.io

Links útiles:
https://wiki.gnome.org/Projects/Vala/GIOSamples
*/
using Gtk;

Entry entServerName;
SpinButton tiempoLimite;
SpinButton puntuacionLimite;
Label lMapas;
string tipo_de_juego;
string maps;
string mapa_inicial;
//static string[] MAPS = {"dm1","dm2","dm6","dm7","dm8","dm9","ctf1","ctf2","ctf3","ctf4","ctf5","ctf6","ctf7"};

Entry nuevaEntrada(string s){
    var entry = new Entry();
    entry.set_text(s);
    return entry;
}
/*
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
*/
int guardar_y_correr(){
    var path = "serverconfig.cfg";
    var file = File.new_for_path (path);
    /* Si el archivo no existe el archivo, lo crea */
    /*if(!file.query_exists ()){
        stderr.printf ("Archivo '%s' no existe.\n", file.get_path ());
        print("Creando archivo %s".printf(file.get_path ()));
        crear_archivo(file);
        return 2;
    }*/
    if(file.query_exists ()){
        try{
            file.delete ();
        }catch(Error e){
        }
    }
    /*Guardar datos*/
    try{
        var dos = new DataOutputStream (file.create (FileCreateFlags.REPLACE_DESTINATION));
        dos.put_string ("sv_name %s\n".printf (entServerName.get_text()));
        dos.put_string ("sv_scorelimit %i\n".printf ((int)puntuacionLimite.get_value()));
        dos.put_string ("sv_timelimit %i\n".printf ((int)tiempoLimite.get_value()));
        dos.put_string ("sv_gametype %s\n".printf (tipo_de_juego));
        dos.put_string ("sv_maprotation %s\n".printf (maps));
        dos.put_string ("sv_map %s\n".printf (mapa_inicial));
    }catch(Error e){
        error("%s",e.message);
    }
    return 0;
}

void generar_aleatorio (){
    maps="";
    var n = 5;
    string[] a = {"dm1","dm2","dm6","dm7","dm8","dm9","ctf1","ctf2","ctf3","ctf4","ctf5","ctf6","ctf7"};
    for (int i = 0; i < n ; i++){
        var r = Random.int_range(0,a.length-1);
        maps += a[r] + " ";
        if (i == 0){
            mapa_inicial = a[r];
        }
        a.move(r,a.length-1,1);
        a.resize(a.length-1);
    }
    print("mapas aleatorio = %s\n".printf(maps));
    lMapas.set_text(maps);
}

int 
main(string[] args){
    Gtk.init(ref args);
    /*Valores inciales*/    
    tipo_de_juego = "dm";
    mapa_inicial = "dm1";
    /*GUI*/
    var window = new Window ();
    window.title = "Configurar servidor de Teeworlds";
    window.set_default_size(400,360);
    window.set_border_width(15);
    window.set_position(Gtk.WindowPosition.CENTER);
    window.destroy.connect (Gtk.main_quit);

    var grid = new Gtk.Grid ();
    grid.orientation = Gtk.Orientation.VERTICAL;
    grid.set_column_spacing(10);
    grid.set_row_spacing(10);

    entServerName = nuevaEntrada ("Servidor GLUD");
    tiempoLimite = new SpinButton.with_range (1, 130, 1);
    tiempoLimite.set_value(10);
    puntuacionLimite = new SpinButton.with_range (1, 50, 1);
    puntuacionLimite.set_value(20);

    Box box = new Box (Gtk.Orientation.VERTICAL, 0);

    RadioButton button1 = new RadioButton.with_label_from_widget (null, "Todos contra todos");
    button1.set_active(true);
	box.pack_start (button1, false, false, 0);
    button1.clicked.connect(() => {
        tipo_de_juego = "dm";
    });

	RadioButton button2 = new RadioButton.with_label_from_widget (button1, "Captura la bandera");
	box.pack_start (button2, false, false, 0);
    button1.clicked.connect(() => {
        tipo_de_juego = "ctf";
    });

    lMapas = new Label("dm1");

    var b_gen_aleatorio = new Button.with_label("Generar");
    b_gen_aleatorio.clicked.connect(generar_aleatorio);

    var button = new Button.with_label ("Guardar");
    button.clicked.connect (() => {
        button.label = "¡Listo!";
        guardar_y_correr();
    });

    /* Organizar objetos en la ventana*/

    grid.attach(new Label("Nombre del servidor"),1,0,1,1);
    grid.attach(entServerName,2,0,10,1);

    grid.attach(new Label("Tiempo Límite"),1,1,1,1);
    grid.attach(tiempoLimite,2,1,10,1);
    grid.attach(new Label("mín"),15,1,1,1);

    grid.attach(new Label("Puntaje Límite"),1,2,1,1);
    grid.attach(puntuacionLimite,2,2,10,1);
    
    grid.attach (new Label ("Mapas"),1,7,1,1);
    grid.attach (b_gen_aleatorio,2,7,7,1);

    grid.attach (lMapas,2,8,8,1);

    grid.attach (new Label ("Mode de Juego"),1,9,1,1);
    grid.attach(box,2,9,7,1);

    grid.attach(button,4,10,1,1);


    window.add (grid);
    window.show_all ();

    Gtk.main ();
    return 0;
}
