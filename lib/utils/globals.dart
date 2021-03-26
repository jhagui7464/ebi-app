library globals;

import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto;

//{"ID":,"UName":"","Email":"","password":"","IdCliente":}
//class and factory constructor
class UserData {
  final int id;
  final String uname;
  final String email;
  final String password;
  final int idcliente;

  UserData({this.id, this.uname, this.email, this.password, this.idcliente});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
        id: json['ID'],
        uname: json['UName'],
        email: json['Email'],
        password: json['password'],
        idcliente: json['IdCliente']);
  }
}

class ClientTable {
  final String po;
  final String trans;
  final String unit;
  final String origin;
  final String destination;
  final String intDate;
  final String unloadDate;
  final String unloadHour;
  final String deliverDate;
  final String deliverHour;
  final String etaDate;
  final String refNum;
  final String observation;
  final String comment;
  ClientTable(
      {this.po,
      this.trans,
      this.unit,
      this.origin,
      this.destination,
      this.intDate,
      this.unloadDate,
      this.unloadHour,
      this.deliverDate,
      this.deliverHour,
      this.etaDate,
      this.refNum,
      this.observation,
      this.comment});

  factory ClientTable.fromJson(Map<String, dynamic> json) {
    return ClientTable(
      po: json['POCliente'],
      trans: json['NombreLineaTransporte'],
      unit: json['EcoSellos'],
      origin: json['ViajeOrigen'],
      destination: json['ViajeDestino'],
      intDate: json['ViajeInicio'],
      unloadDate: json['Fecha Descargado'],
      unloadHour: json['horaDescargado'],
      deliverDate: json['fechaEntregaCliente'],
      deliverHour: json['horaEntregaCliente'],
      etaDate: json['ViajeETA'],
      refNum: json['ViajeReferencia'],
      observation: json['NombreObservacion'],
      comment: json['ViajeNotas'],
    );
  }
}

class InventoryTable {
  final String tramitID;
  final String dateArrived;
  final String factoryDate;
  final String bulkNumber;
  final String productPounds;
  final String productID;
  final String productDescription;
  final String totalExits;
  final String po;
  final String existence;

  InventoryTable({
    this.tramitID,
    this.dateArrived,
    this.factoryDate,
    this.bulkNumber,
    this.productPounds,
    this.productID,
    this.productDescription,
    this.totalExits,
    this.po,
    this.existence,
  });

  factory InventoryTable.fromJson(Map<String, dynamic> json) {
    return InventoryTable(
      tramitID: json['IdFolioTramie'],
      dateArrived: json['FechaLlegada'],
      factoryDate: json['IdClienteFactura'],
      bulkNumber: json['NumeroBultos'],
      productPounds: json['LibrasProducto'],
      productID: json['IdProducto'],
      productDescription: json['DescripcionProductoIngles'],
      totalExits: json['TotalSalidas'],
      po: json['POCliente'],
      existence: json['Existencia'],
    );
  }
}

String generateMd5(String input) {
  return crypto.md5.convert(utf8.encode(input)).toString();
}

String trimString(String str, String ch) {
  if (str == null) {
    return 'Pending';
  }
  int pos = str.indexOf(ch);
  if (pos >= 0) {
    return str.substring(0, pos);
  } else
    return str; // there is nothing to trim; alternatively, return `string.Empty`
}

String stringExists(String str) {
  if (str == null) {
    return 'Pending';
  } else
    return str;
}

String commentExists(String str) {
  if (str == null) {
    return 'None';
  } else
    return str;
}
