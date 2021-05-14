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
  final int priority;
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
      this.comment,
      this.priority});

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
        priority: json['aplicaordenservicio']);
  }
}

class InventoryTable {
  final num tramitID;
  final String dateArrived;
  final num factoryID;
  final num bulkNumber;
  final num productPounds;
  final num productID;
  final String productDescription;
  final num totalExits;
  final String po;
  final num existence;

  InventoryTable({
    this.tramitID,
    this.dateArrived,
    this.factoryID,
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
      factoryID: json['IdClienteFactura'],
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

class Operations {
  final int invoiceID;
  final int processID;
  final String tramitDate;
  final int customsID;
  final String customsName;
  final int factoryID;
  final String clientName;
  final int transportID;
  final int tramitID;
  final String arrivalDate;

  Operations(
      {this.invoiceID,
      this.processID,
      this.tramitDate,
      this.customsID,
      this.customsName,
      this.factoryID,
      this.clientName,
      this.transportID,
      this.tramitID,
      this.arrivalDate});

  factory Operations.fromJson(Map<String, dynamic> json) {
    return Operations(
      invoiceID: json['IdFOlioTramite'],
      processID: json['IdConceptoProceso'],
      tramitDate: json['FechaTramite'],
      customsID: json['IdAduana'],
      customsName: json['NombreAduana'],
      factoryID: json['IdClienteFactura'],
      clientName: json['NombreCLiente'],
      transportID: json['NombreLineaTRansporte'],
      tramitID: json['IdTramite'],
      arrivalDate: json['FechaLLegada'],
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
  if (str == null || str == 'null') {
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
