import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

// ignore: camel_case_types
class camarawidget extends StatefulWidget {
  const camarawidget({ Key? key }) : super(key: key);

  @override
  _camarawidgetState createState() => _camarawidgetState();
}

// ignore: camel_case_types
class _camarawidgetState extends State<camarawidget> {
  @override
  XFile? imageFile;
  String urlimagen="";
  Future<void> _showVentanaDialogo(BuildContext context){
    return showDialog(context: context, 
    ///aqui se construye la pantalla
      builder: (BuildContext context){
          return AlertDialog(
            title: Text("Escoge la opción",
            style: TextStyle(color: Colors.blue)),
            content: SingleChildScrollView(
              child: ListBody(
                children: [ 
                  Divider(height: 1, color: Colors.blue,),
                  ListTile(
                    onTap: (){
                      _abrirgaleria(context);
                    },
                    title: Text("galeria"),
                    leading:Icon(Icons.photo_album_outlined, color: Colors.blue,)
                  ),
                   Divider(height: 1, color: Colors.blue,),
                  ListTile(
                    onTap: (){
                      _abrircamara(context);
                    },
                    title: Text("camara"),
                    leading:Icon(Icons.camera, color: Colors.blue,)
                  )
               
                ],
              ),)
          );
      }
      );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("appcamara"),backgroundColor: Colors.pink,),
      body:Center(
        child:Container(
          child: Column(
            children: [
              Card(
                child: (imageFile==null)?Text("no hay pic")
                :Image.file(File(imageFile!.path)),

              ),
              MaterialButton(
                textColor:Colors.pink,
                onPressed: (){
                  _showVentanaDialogo(context);
                },
                child:Text("selecciona imagen"),
                ),
              MaterialButton(
                textColor:Colors.pink,
                onPressed: (){
                  _subirimagen(context);
                },
                child:Text("sube imagen a la nube"),
                ),
               MaterialButton(
                textColor:Colors.pink,
                onPressed: (){
                  _abreliga();
                },
                child:Text("abre la liga"),
                ),
                MaterialButton(
                textColor:Colors.pink,
                onPressed: (){
                  _comparteliga();
                  Share.share('te paso mi pic'+ urlimagen);
                },
                child:Text("comparte la liga"),
                )
            ],),
        ),
      ),
    );
  }
  void _abrirgaleria(BuildContext context) async{
    final archivo= await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      imageFile=archivo;
    });
    Navigator.pop(context);
  }
    void _abrircamara(BuildContext context) async{
    final archivo= await ImagePicker().pickImage(source: ImageSource.camera);
    setState(() {
      imageFile=archivo;
    });
    Navigator.pop(context);
  }
  void _abreliga() async{
    launch(urlimagen);
  }
    void _comparteliga(){
    Share.share('te paso mi pic'+ urlimagen);
  }
  Future <void> _subirimagen(BuildContext context) async{
    String urllocal="";
    final cloudinary = CloudinaryPublic('lanubedeemma', 'd8peo5hq', cache: false);
    try {
    CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(imageFile!.path, resourceType: CloudinaryResourceType.Image),
    );
      urllocal= response.secureUrl;
    print(response.secureUrl);
    } on CloudinaryException catch (e) {
      print(e.message);
      print(e.request);
    }
    setState((){
      urlimagen=urllocal;
    }
    );
  }
}
