import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker_flutter/models/database.helper.dart';
import 'package:image_picker_flutter/models/user.model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget { 
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image picker ejemplo Yaggar',
      theme: ThemeData(      
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Image Picker Yaggar'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key); 
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> { 
  //Variable global
  File _image;  

  @override
  void initState() {
    super.initState();  
    //Precargamos la imagen
    getImageFromDB();     
  }
  
  //Obtenemos el path de la imagen guardada
  Future getImageFromDB() async {   
    User user = await DBProviderHelper.db.getUser(1);   

    if(user == null) 
    {
        return;
    }

    File fileimage = await getLocalFile(user.avatar);
     setState(() {
       _image = fileimage;
    });
  }

  //Alerta
  Future<void> myAlert(BuildContext context, String title, String content) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  //convertimos el path string a file
  Future<File> getLocalFile(String filename) async {  
    File f = new File('$filename');
    return f;
  }

  //obtenemos la imagen de la galeria
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);        

    setState(() {
      _image = image;      
    });
  }  

  //Guardamos la imagen en la base de datos
  Future saveImage() async {      
   var usuario = User(firstName: "jose", lastName: "sanchez", avatar: _image.path.toString(), blocked: false);
   try
   {
     await DBProviderHelper.db.newUser(usuario);
     myAlert(this.context, "Aviso!", "Imagen guardada correctamente, cierra la aplicacion completamente y cuando la abras, la imagen guardada se cargara");
   } catch (ex)
   {
     myAlert(this.context, "Aviso!", "Se ha presentado un error, intente nuevamente");
     print(ex);
   }
    
  }

  //retornamos la imagen por default o la de la variable global
  Widget getDataImage(BuildContext context) {    
    if(_image == null)
    {
      return Image.asset('assets/images/yaggar.png');
    }
    else
    {
      return Image.file(_image);
    }   
  }

  @override
  Widget build(BuildContext context) {   
    return Scaffold(
      appBar: AppBar(        
        title: Text(widget.title),
      ),
      body: 
      SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
               
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 50.0),
                  child: getDataImage(context),
                ),
                Column(
                  children: <Widget>[
                    Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: SizedBox(
                      height: 40.0,
                      child: new RaisedButton(
                        elevation: 5.0,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)
                        ),
                        color: Colors.blue,
                        child:  new Text(
                          'Agegar Imagen',
                            style: new TextStyle(fontSize: 20.0, color: Colors.white),                 
                        ),                 
                        onPressed: () async {                     
                          getImage();
                        },                 
                      ),
                    ),
                   ),
                   Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: SizedBox(
                      height: 40.0,
                      child: new RaisedButton(
                        elevation: 5.0,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)
                        ),
                        color: Colors.pink,
                        child:  new Text(
                          'Guardar imagen',
                            style: new TextStyle(fontSize: 20.0, color: Colors.white),                 
                        ),                 
                        onPressed: () async {                     
                          saveImage();
                        },                 
                      ),
                    ),
                  ),
                   Padding(
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    child: SizedBox(
                      height: 40.0,
                      child: new RaisedButton(
                        elevation: 5.0,
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)
                        ),
                        color: Colors.orange,
                        child:  new Text(
                          'Recargar imagen guardada',
                            style: new TextStyle(fontSize: 20.0, color: Colors.white),                 
                        ),                 
                        onPressed: () async {                     
                          getImageFromDB();
                        },                 
                      ),
                    ),
                  )
                  ],
                )
              ],
            )   
          )
        )
    );
  }

}
